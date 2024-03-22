import UIKit

/// Filter settings screen navigation manager interface
protocol FiltersRouterProtocol: AnyObject {
    /// Closes filter settings screen
    func close()
}

/// Filter settings screen navigation manager
final class FiltersRouter: FiltersRouterProtocol {
    
    // MARK: - Properties
    
    private weak var rootViewController: UIViewController?
    
    // MARK: - Public
    
    /// Assigns root view controller, from which navigation happes
    /// - Parameter rootViewController: Root navigation controller
    func setRootViewController(_ rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func close() {
        rootViewController?.dismiss(animated: true)
    }
}
