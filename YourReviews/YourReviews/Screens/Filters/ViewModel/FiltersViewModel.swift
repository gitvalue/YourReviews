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
        
        fileprivate init(_ selectedStarIndex: Int?, _ validRange: ClosedRange<Int>) {
            self.stars = stride(from: 0, to: validRange.upperBound - validRange.lowerBound + 1, by: 1).map { index in
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
            starsFilterModel = StarsFilterModel(selectedStarIndex, filter.validRange)
        }
    }
    
    @Published
    private(set) var starsFilterModel: StarsFilterModel
    
    let applyButtonTitle: String = "Apply"
    
    private var subscriptions: [AnyCancellable] = []
    private let filter: ReviewsFilterProtocol
    private let router: FiltersRouterProtocol
    
    // MARK: - Initialisers
    
    init(filter: ReviewsFilterProtocol, router: FiltersRouterProtocol) {
        self.filter = filter
        self.router = router
        
        if let rating = filter.rating {
            selectedStarIndex = rating - 1
        }
        
        starsFilterModel = StarsFilterModel(selectedStarIndex, filter.validRange)
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
        publisher.sink { [weak self] in
            guard let self else { return }
            
            if let selectedStarIndex = self.selectedStarIndex {
                self.filter.rating = self.filter.validRange.lowerBound + selectedStarIndex
            } else {
                self.filter.rating = nil
            }
            
            self.router.close()
        }.store(
            in: &subscriptions
        )
    }
}
