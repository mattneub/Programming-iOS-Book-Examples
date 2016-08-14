
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

class MyTabBarController : UITabBarController {
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(self.dynamicType) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(#function) \(action) \(result)")
        return result
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(#function) \(result)")
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(#function)")
        }
    }
    
    override var selectedViewController: UIViewController? {
        get {
            return super.selectedViewController
        }
        set {
            print("\(self.dynamicType) set \(#function)")
            super.selectedViewController = newValue
        }
    }


}

class MyNavController : UINavigationController {
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(self.dynamicType) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(#function) \(action) \(result)")
        return result
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(#function) \(result)")
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(#function)")
        }
    }
        
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        print("\(self.dynamicType) \(#function)")
        return super.popToViewController(viewController, animated:animated)
    }


}

