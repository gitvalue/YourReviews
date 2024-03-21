import UIKit

protocol ReviewsListRouterProtocol: AnyObject {
    func openFilters()
    func openDetails(withRating rating: String, author: String, title: String, review: String)
}

final class ReviewsListRouter: ReviewsListRouterProtocol {
    
    // MARK: - Properties
    
    private weak var rootViewController: UIViewController?
    
    // MARK: - Public
    
    func setRootViewController(_ rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func openFilters() {
        let factory = FiltersViewControllerFactory()
        let viewController = factory.create()
        viewController.sheetPresentationController?.detents = [
            .custom { _ in
                return viewController.preferredContentSize.height
            }
        ]
        
        rootViewController?.present(viewController, animated: true)
    }
    
    func openDetails(withRating rating: String, author: String, title: String, review: String) {
        let factory = ReviewDetailsViewControllerFactory()
        let viewController = factory.create(withRating: rating, author: author, title: title, review: review)
        rootViewController?.present(viewController: viewController, animated: true, pushIfPossible: true)
    }
}
