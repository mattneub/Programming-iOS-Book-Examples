

import UIKit

class ViewController : UIViewController {
    
    
    @IBAction func unwind(seg:UIStoryboardSegue!) {
        println("view controller 1 unwind is called")
    }

    override func respondsToSelector(aSelector: Selector) -> Bool {
        if NSStringFromSelector(aSelector) == "unwind:" {
            println("\(self) is asked if it responds to \(aSelector)")
        }
        let result = super.respondsToSelector(aSelector)
        return result
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        var result = true
        
        println("view controller 1 can perform returns \(result)")
        return result
    }


    override func viewControllerForUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject!) -> UIViewController? {
        
        var result : UIViewController? = nil
        
        println("view controller 1 vc for unwind segue called...")
        let vc = super.viewControllerForUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        println("view controller 1 returns \(vc) from vc for unwind segue")
        result = vc
        return result
    }

    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        println("view controller 1 was asked for segue")
        // can't return nil
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
    }


}
