import UIKit

final class ReviewsListViewControllerFactory {
    func create() -> UIViewController {
        let viewModel = ReviewsListViewModel()
        let result = ReviewsListViewController(viewModel: viewModel)
        
        return result
    }
}
