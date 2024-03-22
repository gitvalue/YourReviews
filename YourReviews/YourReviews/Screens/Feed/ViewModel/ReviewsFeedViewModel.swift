import Combine
import Foundation

/// Reviews feed business logic
final class ReviewsFeedViewModel {
    
    // MARK: - Model
    
    /// Reviews feed screen header model
    struct ReviewsFeedHeaderModel {
        /// Filter button title text
        let filterButtonTitle: String = "Filters"
        /// Top occuring words title text
        let topWordsTitle: String = "Top 3 words:"
        /// Top occuring words
        let topWords: String
        /// Filter button press event publisher
        let filterButtonPressEventPublisher: PassthroughSubject<Void, Never>
    }
    
    /// Reviews feed list cell model
    struct ReviewCellModel: Hashable {
        /// Rating text
        let rating: String
        /// Author name
        let author: String
        /// Review title text
        let title: String
        /// Review contents text
        let review: String
        
        fileprivate let dto: ReviewsFeedEntryDto
        
        fileprivate init(dto: ReviewsFeedEntryDto) {
            let formatter = ReviewFormatter(review: dto)
            rating = formatter.rating
            author = formatter.author
            title = formatter.title
            review = formatter.content
            self.dto = dto
        }
    }
    
    // MARK: - Properties
    
    /// Show alert event publisher
    let alertEventPublisher = PassthroughSubject<(title: String, mesage: String, action: String), Never>()
    /// End refreshing event publisher
    let refreshEndEventPublisher = PassthroughSubject<Void, Never>()
    
    /// Reviews feed list header model
    @Published
    private(set) var header: ReviewsFeedHeaderModel?
    
    /// Reviews list models
    @Published
    private(set) var reviews: [ReviewCellModel] = []
    
    private let filterButtonPressEventPublisher = PassthroughSubject<Void, Never>()
    
    private var feed: [ReviewsFeedEntryDto] = [] {
        didSet {
            filterDataSource(byRating: filter.rating)
        }
    }
    
    private var subscriptions: [AnyCancellable] = []
    private let service: ReviewsFeedServiceProtocol
    private let router: ReviewsFeedRouterProtocol
    private let filter = ReviewsFilter(validRange: 1...5)
    
    // MARK: - Initialisers
    
    /// Designated initialiser
    /// - Parameters:
    ///   - service: App reviews feed service
    ///   - router: Reviews feed navigation manager object
    init(service: ReviewsFeedServiceProtocol, router: ReviewsFeedRouterProtocol) {
        self.service = service
        self.router = router
        
        subscribeToFilterButtonPressEvent()
        subscribeToFilterChangeEvent()
        
        fetchFeed()
    }
    
    // MARK: - Public
    
    /// Subscribes view model to cell selection event
    /// - Parameter publisher: Cell selection event publisher
    func subscribeToCellSelectionEvent(_ publisher: AnyPublisher<ReviewCellModel, Never>) {
        publisher.sink { [router] model in
            router.openDetails(model.dto)
        }.store(
            in: &subscriptions
        )
    }
    
    /// Subscribes view model to list refresh request event
    /// - Parameter publisher: List refresh request even publisher
    func subscribeToPullToRefreshEvent(_ publisher: AnyPublisher<Void, Never>) {
        publisher.sink { [weak self] in
            self?.fetchFeed()
        }.store(
            in: &subscriptions
        )
    }
    
    // MARK: - Private
    
    private func subscribeToFilterButtonPressEvent() {
        filterButtonPressEventPublisher.sink { [router, filter] in
            router.openFilters(filter)
        }.store(
            in: &subscriptions
        )
    }
    
    private func subscribeToFilterChangeEvent() {
        filter.$rating.sink { [weak self] rating in
            self?.filterDataSource(byRating: rating)
        }.store(
            in: &subscriptions
        )
    }
    
    private func fetchFeed() {
        service.getReviewsFeed(forAppWithId: "474495017").sink(
            receiveCompletion: { [weak self] result in
                self?.refreshEndEventPublisher.send()
                if case .failure = result {
                    self?.alertEventPublisher.send((title: "Error", mesage: "Something went wrong", action: "Dismiss"))
                }
            },
            receiveValue: { [weak self] feed in
                self?.feed = feed
                self?.refreshEndEventPublisher.send()
            }
        ).store(
            in: &subscriptions
        )
    }
    
    private func filterDataSource(byRating filterRating: Int?) {
        var reviews: [ReviewCellModel] = []
        var wordsHistogram: [String: Int] = [:]
        
        for entry in feed {
            if let filterRating, let reviewRating = Int(entry.rating), filterRating != reviewRating {
                continue
            }
            
            let words = entry.content.components(
                separatedBy: .whitespacesAndNewlines
            ).filter {
                3 < $0.count
            }
            
            for word in words {
                wordsHistogram[word, default: 0] += 1
            }
            
            reviews.append(ReviewCellModel(dto: entry))
        }
        
        let top3Words = wordsHistogram.sorted {
            ($1.value == $0.value) ? ($1.key < $0.key) : ($1.value < $0.value)
        }.prefix(
            3
        ).map {
            $0.key
        }
        
        header = ReviewsFeedHeaderModel(
            topWords: top3Words.joined(separator: ", "),
            filterButtonPressEventPublisher: filterButtonPressEventPublisher
        )
        
        self.reviews = reviews
    }
}
