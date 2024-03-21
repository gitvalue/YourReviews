import UIKit

final class FiltersViewControllerFactory {
    func create() -> UIViewController {
        let router = FiltersRouter()
        let viewModel = FiltersViewModel(router: router)
        let result = FiltersViewController(viewModel: viewModel)
        router.setRootViewController(result)
        
        return result
    }
}
