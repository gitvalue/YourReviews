import Networking
import UIKit

final class ReviewsListViewControllerFactory {
    func create() -> UIViewController {
        let service = ReviewsFeedService { JSONRestApiRequester(apiUrl: $0) }
        let router = ReviewsListRouter()
        let viewModel = ReviewsListViewModel(service: service, router: router)
        let result = ReviewsListViewController(viewModel: viewModel)
        router.setRootViewController(result)
        
        return result
    }
}
