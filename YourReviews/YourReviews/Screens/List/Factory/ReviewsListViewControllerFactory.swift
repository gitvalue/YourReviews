import UIKit

final class ReviewsListViewControllerFactory {
    func create() -> UIViewController {
        let router = ReviewsListRouter()
        let viewModel = ReviewsListViewModel(router: router)
        let result = ReviewsListViewController(viewModel: viewModel)
        router.setRootViewController(result)
        
        return result
    }
}
