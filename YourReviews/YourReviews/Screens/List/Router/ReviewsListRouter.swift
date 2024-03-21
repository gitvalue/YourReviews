import UIKit

protocol ReviewsListRouterProtocol: AnyObject {
    func openFilters(_ filter: ReviewsFilterProtocol)
    func openDetails(_ review: ReviewsFeedEntryDto)
}

final class ReviewsListRouter: ReviewsListRouterProtocol {
    
    // MARK: - Properties
    
    private weak var rootViewController: UIViewController?
    
    // MARK: - Public
    
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
