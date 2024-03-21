import Combine
import Foundation

final class ReviewsListViewModel {
    
    // MARK: - Model
    
    struct ReviewsListHeaderModel {
        let filterTitle: String = "Filters"
        let topWordsTitle: String = "Top 3 words:"
        let topWords: String
        let filterButtonPressEventPublisher: PassthroughSubject<Void, Never>
    }
    
    struct ReviewCellModel: Hashable {
        let rating: String
        let author: String
        let title: String
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
    
    let alertEventPublisher = PassthroughSubject<(title: String, mesage: String, action: String), Never>()
    let refreshEndEventPublisher = PassthroughSubject<Void, Never>()
    
    @Published
    private(set) var header: ReviewsListHeaderModel
    
    @Published
    private(set) var reviews: [ReviewCellModel] = []
    
    private let filterButtonPressEventPublisher: PassthroughSubject<Void, Never>
    
    private var feed: [ReviewsFeedEntryDto] = [] {
        didSet {
            filterDataSource(byRating: filter.rating)
        }
    }
    
    private var subscriptions: [AnyCancellable] = []
    private let service: ReviewsFeedServiceProtocol
    private let router: ReviewsListRouterProtocol
    private let filter = ReviewsFilter(validRange: 1...5)
    
    // MARK: - Initialisers
    
    init(service: ReviewsFeedServiceProtocol, router: ReviewsListRouterProtocol) {
        self.service = service
        self.router = router
        
        let filterButtonPressEventPublisher = PassthroughSubject<Void, Never>()
        self.filterButtonPressEventPublisher = filterButtonPressEventPublisher
        
        self.header = ReviewsListHeaderModel(
            topWords: "Best, bank, ever",
            filterButtonPressEventPublisher: filterButtonPressEventPublisher
        )
        
        subscribeToFilterButtonPressEvent()
        subscribeToFilterChangeEvent()
        
        fetchFeed()
    }
    
    // MARK: - Public
    
    func subscribeOnCellSelectionEvent(_ publisher: AnyPublisher<ReviewCellModel, Never>) {
        publisher.sink { [router] model in
            router.openDetails(model.dto)
        }.store(
            in: &subscriptions
        )
    }
    
    func subscribeOnPullToRefreshEvent(_ publisher: AnyPublisher<Void, Never>) {
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
            
            let words = entry.content.components(separatedBy: .whitespacesAndNewlines).filter { 3 < $0.count }
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
        
        header = ReviewsListHeaderModel(
            topWords: top3Words.joined(separator: ", "),
            filterButtonPressEventPublisher: filterButtonPressEventPublisher
        )
        
        self.reviews = reviews
    }
}
