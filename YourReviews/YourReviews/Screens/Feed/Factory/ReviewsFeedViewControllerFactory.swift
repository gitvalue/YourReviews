import Networking
import UIKit

/// Reviews feed view controller factory
final class ReviewsFeedViewControllerFactory {
    /// Creates reviews feed view controller
    /// - Returns: Reviews feed view controller
    func create() -> UIViewController {
        let service = ReviewsFeedService { JSONRestApiRequester(apiUrl: $0) }
        let router = ReviewsFeedRouter()
        let viewModel = ReviewsFeedViewModel(service: service, router: router)
        let result = ReviewsFeedViewController(viewModel: viewModel)
        router.setRootViewController(result)
        
        return result
    }
}
