

import UIKit

class ViewController2 : UIViewController {
    
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

    @IBAction func unwind(seg:UIStoryboardSegue!) {
        println("view controller 2 unwind is called")
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        var result = false
        
        let which = 1
        switch which {
        case 1:
            result = true
        case 2:
            result = false
        default: break
        }
        
        println("view controller 2 can perform returns \(result)")
        return result
    }

    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String) -> UIStoryboardSegue {
        println("\(self) was asked for segue")
        // can't return nil
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
    }

}
