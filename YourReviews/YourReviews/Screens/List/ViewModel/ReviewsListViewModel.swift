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
    }
    
    // MARK: - Properties
    
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
            router.openDetails(withRating: model.rating, author: model.author, title: model.title, review: model.review)
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
            receiveCompletion: { _ in },
            receiveValue: { [weak self] feed in
                self?.feed = feed
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
            
            reviews.append(cellModel(fromDto: entry))
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
        
    private func cellModel(fromDto dto: ReviewsFeedEntryDto) -> ReviewCellModel {
        let numberOfStars = Int(dto.rating) ?? 0
        let ratingPrefix = Array<String>(repeating: "⭐️", count: numberOfStars).joined()
        let ratingSuffix = "(ver: \(dto.version))"
        let rating = ratingPrefix + ratingSuffix
        
        return ReviewCellModel(
            rating: rating,
            author: dto.author.name,
            title: dto.title,
            review: dto.content
        )
    }
}
