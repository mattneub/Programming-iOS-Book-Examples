
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

class MyTabBarController : UITabBarController {
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(type(of:self)) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(type(of:self)) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(type(of:self)) \(#function) \(action) \(result)")
        return result
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(type(of:self)) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(type(of:self)) \(#function) \(result)")
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwind" {
            print("\(type(of:self)) \(#function)")
        }
    }
    
    override var selectedViewController: UIViewController? {
        get {
            return super.selectedViewController
        }
        set {
            print("\(type(of:self)) set \(#function)")
            super.selectedViewController = newValue
        }
    }


}

class MyNavController : UINavigationController {
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(type(of:self)) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(type(of:self)) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(type(of:self)) \(#function) \(action) \(result)")
        return result
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(type(of:self)) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(type(of:self)) \(#function) \(result)")
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwind" {
            print("\(type(of:self)) \(#function)")
        }
    }
        
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        print("\(type(of:self)) \(#function)")
        return super.popToViewController(viewController, animated:animated)
    }


}

