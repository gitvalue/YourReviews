import UIKit

protocol ReviewsListRouterProtocol: AnyObject {
    func openDetails(withRating rating: String, author: String, title: String, review: String)
}

final class ReviewsListRouter: ReviewsListRouterProtocol {
    
    // MARK: - Properties
    
    private weak var rootViewController: UIViewController?
    
    // MARK: - Public
    
    func setRootViewController(_ rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func openDetails(withRating rating: String, author: String, title: String, review: String) {
        let factory = ReviewDetailsViewControllerFactory()
        let viewController = factory.create(withRating: rating, author: author, title: title, review: review)
        rootViewController?.present(viewController: viewController, animated: true, pushIfPossible: true)
    }
}
