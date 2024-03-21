import UIKit

extension UIViewController {
    func present(
        viewController: UIViewController,
        animated: Bool,
        pushIfPossible: Bool,
        completion: (() -> ())? = nil
    ) {
        let navigationController = [self as? UINavigationController, navigationController].compactMap { $0 }.first
        
        if pushIfPossible, let navigationController {
            navigationController.pushViewController(viewController, animated: animated)
            completion?()
        } else {
            present(viewController, animated: animated, completion: completion)
        }
    }
}
