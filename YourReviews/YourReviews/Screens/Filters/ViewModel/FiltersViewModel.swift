import Combine
import Foundation

final class FiltersViewModel {
    
    // MARK: - Model
    
    struct StarsFilterModel {
        struct StarModel {
            let isFilled: Bool
        }
        
        let title: String = "Stars:"
        let stars: [StarModel]
        
        fileprivate init(selectedStarIndex: Int?, maximumNumberOfStars: Int) {
            self.stars = stride(from: 0, to: maximumNumberOfStars, by: 1).map { index in
                if let selectedStarIndex {
                    return StarModel(isFilled: index <= selectedStarIndex)
                } else {
                    return StarModel(isFilled: false)
                }
            }
        }
    }
    
    // MARK: - Properties
    
    private var selectedStarIndex: Int? {
        didSet {
            starsFilter = StarsFilterModel(selectedStarIndex: selectedStarIndex, maximumNumberOfStars: maximumNumberOfStars)
        }
    }
    
    @Published
    private(set) var starsFilter: StarsFilterModel
    
    let applyButtonTitle: String = "Apply"
    
    private let maximumNumberOfStars = 5
    private var subscriptions: [AnyCancellable] = []
    private let router: FiltersRouterProtocol
    
    // MARK: - Initialisers
    
    init(router: FiltersRouterProtocol) {
        self.router = router
        starsFilter = StarsFilterModel(selectedStarIndex: selectedStarIndex, maximumNumberOfStars: maximumNumberOfStars)
    }
    
    // MARK: - Public
    
    func subscribeToStarSelectionEvent(_ publisher: AnyPublisher<Int, Never>) {
        publisher.sink { [weak self] index in
            guard let self else { return }
            self.selectedStarIndex = self.selectedStarIndex == index ? nil : index
        }.store(
            in: &subscriptions
        )
    }
    
    func subscribeToApplyButtonPressEvent(_ publisher: AnyPublisher<Void, Never>) {
        publisher.sink { [router] in
            router.close()
        }.store(
            in: &subscriptions
        )
    }
}
