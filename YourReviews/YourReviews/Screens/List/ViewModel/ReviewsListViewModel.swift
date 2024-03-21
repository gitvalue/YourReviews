import Combine
import Foundation

final class ReviewsListViewModel {
    
    // MARK: - Model
    
    struct ReviewsListHeaderModel {
        let filterTitle: String
        let topWordsTitle: String
        let topWords: String
        let filterButtonPressEventPublisher: PassthroughSubject<Void, Never>
    }
    
    struct ReviewCellModel: Hashable {
        let title: String
        let rating: String
        let author: String
        let review: String
        
        let id: Int = Self.nextId()
        
        private static var seed: Int = 0
        
        static func nextId() -> Int {
            seed += 1
            return seed
        }
    }
    
    // MARK: - Properties
    
    @Published
    private(set) var header: ReviewsListHeaderModel
    
    @Published
    private(set) var reviews: [ReviewCellModel] = stride(from: 0, to: 20, by: 1).map { _ in .init(title: "Title", rating: "⭐️⭐️⭐️", author: "Me", review: "Good") }
    
    private let filterButtonPressEventPublisher: PassthroughSubject<Void, Never>
    
    private var subscriptions: [AnyCancellable] = []
    private let router: ReviewsListRouterProtocol
    
    // MARK: - Initialisers
    
    init(router: ReviewsListRouterProtocol) {
        self.router = router
        
        let filterButtonPressEventPublisher = PassthroughSubject<Void, Never>()
        self.filterButtonPressEventPublisher = filterButtonPressEventPublisher
        
        self.header = ReviewsListHeaderModel(
            filterTitle: "Filters",
            topWordsTitle: "Top words:",
            topWords: "Best, bank, ever",
            filterButtonPressEventPublisher: filterButtonPressEventPublisher
        )
        
        subscribeToFilterButtonPressEvent()
    }
    
    // MARK: - Public
    
    func subscribeOnCellSelectionEvent(_ publisher: AnyPublisher<ReviewCellModel, Never>) {
        publisher.sink { [router] model in
            router.openDetails(withRating: model.rating, author: model.author, title: model.title, review: model.review)
        }.store(
            in: &subscriptions
        )
    }
    
    private func subscribeToFilterButtonPressEvent() {
        filterButtonPressEventPublisher.sink { [router] in
            router.openFilters()
        }.store(
            in: &subscriptions
        )
    }
}
