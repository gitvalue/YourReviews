import UIKit

protocol FiltersRouterProtocol: AnyObject {
    func close()
}

final class FiltersRouter: FiltersRouterProtocol {
    
    // MARK: - Properties
    
    private weak var rootViewController: UIViewController?
    
    // MARK: - Public
    
    func setRootViewController(_ rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func close() {
        rootViewController?.dismiss(animated: true)
    }
}
