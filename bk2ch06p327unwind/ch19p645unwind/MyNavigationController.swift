import UIKit

class MyNavigationController : UINavigationController {
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        if NSStringFromSelector(aSelector) == "unwind:" {
            println("\(self) is asked if it responds to \(aSelector)")
        }
        let result = super.respondsToSelector(aSelector)
        return result
    }
    
    override func viewControllerForUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject!) -> UIViewController? {
        
        var result : UIViewController? = nil
        
        println("navigation view controller's view controller for unwind is called...")
        let which = 1
        switch which {
        case 1:
            let vc = self.viewControllers[0] as UIViewController
            println("\(self) returns \(vc) from vc for unwind segue")
            result = vc
        case 2:
            let vc = super.viewControllerForUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
            println("\(self) returns \(vc) from vc for unwind segue")
            result = vc
        default: break
        }
        
        return result
    }
    
    /*
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String) -> UIStoryboardSegue {
        println("\(self) was asked for segue")
        return UIStoryboardSegue(identifier: identifier, source: fromViewController, destination: toViewController, performHandler: {
            fromViewController.presentingViewController!.dismissViewControllerAnimated(true, completion: {
                _ in
                self.popToViewController(toViewController, animated: true)
                return; // argh, swift!
                })
            })
    }
*/
    
}
