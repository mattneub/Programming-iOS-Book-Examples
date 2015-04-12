import UIKit

class MyNavigationController : UINavigationController {
    
    /*
    Again the key thing is to look at the difference between iOS 7 and iOS 8
*/
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        if NSStringFromSelector(aSelector) == "unwind:" {
            println("nav controller is asked if it responds to \(aSelector)")
        }
        let result = super.respondsToSelector(aSelector)
        return result
    }
    
    override func viewControllerForUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject!) -> UIViewController? {
        
        var result : UIViewController? = nil
        
        println("nav controller's view controller for unwind is called...")
        let which = 1
        switch which {
        case 1:
            let vc = self.viewControllers[0] as! UIViewController
            println("nav controller returns \(vc) from vc for unwind segue")
            result = vc
        case 2:
            let vc = super.viewControllerForUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
            println("nav controller returns \(vc) from vc for unwind segue")
            result = vc
        default: break
        }
        
        return result
    }
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        println("nav controller was asked for segue")
        
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
    
}
