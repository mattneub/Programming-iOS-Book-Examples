
import UIKit

class ViewController3 : UIViewController {
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        if NSStringFromSelector(aSelector) == "unwind:" {
            println("\(self) is asked if it responds to \(aSelector)")
        }
        let result = super.respondsToSelector(aSelector)
        return result
    }

    override func viewControllerForUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject!) -> UIViewController? {
        
        var result : UIViewController? = nil
        
        let vc = super.viewControllerForUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        println("\(self) returns \(vc) from vc for unwind segue")
        result = vc
        return result
    }

    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        println("\(self) was asked for segue")
        // can't return nil
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
    }
    
    @IBAction func unwind(seg:UIStoryboardSegue!) {
        println("view controller 3 unwind is never called")
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        println("view controller 3 can perform is never called")
        return false
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        println("view controller 3 should perform returns true")
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println("view controller 3 prepare for segue is called")
    }

}
