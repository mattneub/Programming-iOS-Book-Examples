import UIKit

class MyNavigationController : UINavigationController {
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        if NSStringFromSelector(aSelector) == "unwind:" {
            print("nav controller is asked if it responds to \(aSelector)")
        }
        let result = super.respondsToSelector(aSelector)
        return result
    }
    
    override func allowedChildViewControllersForUnwindingFromSource(source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwindingFromSource(source)
        print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        return result
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(__FUNCTION__) \(subsequentVC)")
        super.unwindForSegue(unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        return result
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        }
        return result
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__)")
        }
    }
    
    /*
    
    override func viewControllerForUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject!) -> UIViewController? {
        
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
            if fromViewController == self.presentedViewController {
                return UIStoryboardSegue(identifier: identifier,
                    source: fromViewController,
                    destination: toViewController) {
                        self.dismissViewControllerAnimated(true) {
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
