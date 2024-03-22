import Combine
import Foundation

/// FIlters screen business logic
final class FiltersViewModel {
    
    // MARK: - Model
    
    /// Ratings filter setting model
    struct StarsFilterModel {
        /// Star icon model
        struct StarModel {
            /// Controls if star icon is filled
            let isFilled: Bool
        }
        
        /// Setting title text
        let title: String = "Stars:"
        /// Stars models
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
    
    /// Rating setting model
    @Published
    private(set) var starsFilterModel: StarsFilterModel
    
    /// Apply button title text
    let applyButtonTitle: String = "Apply"
    
    private var subscriptions: [AnyCancellable] = []
    private let filter: ReviewsFilterProtocol
    private let router: FiltersRouterProtocol
    
    // MARK: - Initialisers
    
    /// Designated initialiser
    /// - Parameters:
    ///   - filter: Filter settings object
    ///   - router: Navigation manager
    init(filter: ReviewsFilterProtocol, router: FiltersRouterProtocol) {
        self.filter = filter
        self.router = router
        
        if let rating = filter.rating {
            selectedStarIndex = rating - 1
        }
        
        starsFilterModel = StarsFilterModel(selectedStarIndex, filter.validRange)
    }
    
    // MARK: - Public
    
    /// Subscribes view model to star selection event
    /// - Parameter publisher: Event publisher object
    func subscribeToStarSelectionEvent(_ publisher: AnyPublisher<Int, Never>) {
        publisher.sink { [weak self] index in
            guard let self else { return }
            self.selectedStarIndex = self.selectedStarIndex == index ? nil : index
        }.store(
            in: &subscriptions
        )
    }
    
    /// Subscribes view model to apply button press event
    /// - Parameter publisher: Event publisher object
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
