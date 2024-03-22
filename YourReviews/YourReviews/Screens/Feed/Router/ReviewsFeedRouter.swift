import UIKit

/// Reviews feed screen navigation manager interface
protocol ReviewsFeedRouterProtocol: AnyObject {
    /// Opens filter settings screen
    /// - Parameter filter: Filter settings object
    func openFilters(_ filter: ReviewsFilterProtocol)
    
    /// Opens review details screen
    /// - Parameter review: Review details DTO
    func openDetails(_ review: ReviewsFeedEntryDto)
}

final class ReviewsFeedRouter: ReviewsFeedRouterProtocol {
    
    // MARK: - Properties
    
    private weak var rootViewController: UIViewController?
    
    // MARK: - Public
    
    /// Assigns root view controller, from which navigation happens
    /// - Parameter rootViewController: Root view controller
    func setRootViewController(_ rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func openFilters(_ filter: ReviewsFilterProtocol) {
        let factory = FiltersViewControllerFactory()
        let viewController = factory.create(withFilter: filter)
        viewController.sheetPresentationController?.detents = [
            .custom { _ in
                return viewController.preferredContentSize.height
            }
        ]
        
        rootViewController?.present(viewController, animated: true)
    }
    
    func openDetails(_ review: ReviewsFeedEntryDto) {
        let factory = ReviewDetailsViewControllerFactory()
        let viewController = factory.create(withReview: review)
        rootViewController?.present(viewController: viewController, animated: true, pushIfPossible: true)
    }
}
