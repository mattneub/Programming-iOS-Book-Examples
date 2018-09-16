import UIKit

class MyNavigationController : UINavigationController {
    
    override func responds(to aSelector: Selector) -> Bool {
        if NSStringFromSelector(aSelector) == "unwind:" {
            print("nav controller is asked if it responds to \(aSelector)")
        }
        let result = super.responds(to: aSelector)
        return result
    }
    
    override func allowedChildrenForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildrenForUnwinding(from: source)
        print("\(type(of:self)) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        print("\(type(of:self)) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towards: subsequentVC)
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

    
    /*
    
    override func viewControllerForUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: Any!) -> UIViewController? {
        
        var result : UIViewController? = nil
        
        print("nav controller's view controller for unwind is called...")
        let which = 1
        switch which {
        case 1:
            let vc = self.viewControllers[0] as! UIViewController
            print("nav controller returns \(vc) from vc for unwind segue")
            result = vc
        case 2:
            let vc = super.viewControllerForUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
            print("nav controller returns \(vc) from vc for unwind segue")
            result = vc
        default: break
        }
        
        return result
    }
    
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        print("nav controller was asked for segue")
        
        // are we in the very specific situation where
        // we are unwinding from vc 3 thru vc 2 to vc 1?
        
        let vcs = self.viewControllers as! [UIViewController]
        if vcs.count == 2 && toViewController == vcs[0] {
            if fromViewController == self.presented {
                return UIStoryboardSegue(identifier: identifier,
                    source: fromViewController,
                    destination: toViewController) {
                        self.dismiss(animated:true) {
                            _ in
                            self.popToViewController(
                                toViewController, animated: true)
                            return // argh, swift!
                        }
                }
            }
        }
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
        }
*/
        
    
}
