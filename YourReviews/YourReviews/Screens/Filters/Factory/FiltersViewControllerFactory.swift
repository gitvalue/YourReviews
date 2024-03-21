import UIKit

final class FiltersViewControllerFactory {
    func create(withFilter filter: ReviewsFilterProtocol) -> UIViewController {
        let router = FiltersRouter()
        let viewModel = FiltersViewModel(filter: filter, router: router)
        let result = FiltersViewController(viewModel: viewModel)
        router.setRootViewController(result)
        
        return result
    }
}
