import UIKit

/// Filter settings view controller factory
final class FiltersViewControllerFactory {
    /// Creates filter settings view controller
    /// - Parameter filter: Filter settings object
    /// - Returns: Filter settings view controller
    func create(withFilter filter: ReviewsFilterProtocol) -> UIViewController {
        let router = FiltersRouter()
        let viewModel = FiltersViewModel(filter: filter, router: router)
        let result = FiltersViewController(viewModel: viewModel)
        router.setRootViewController(result)
        
        return result
    }
}
