
import UIKit

class MyNavController : UINavigationController {
    
    override var description : String {
        get {
            return "MyNavController"
        }
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let ok = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        println("I \(self) am being asked can perform from \(fromViewController), and I am answering \(ok)")
        return ok
    }
    
    override func viewControllerForUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject!) -> UIViewController? {
        println("I \(self) will be asked for vc-for-unwind")
        let vc = super.viewControllerForUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        println("I \(self) was asked for vc-for-unwind, and I am returning \(vc!)")
        return vc
    }
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        println("I \(self) will be asked for the segue")
        let seg = super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
        println("I \(self) was asked for the segue, and I am returning \(seg) \(seg.identifier)")
        return seg
    }
    
    @IBAction func doUnwind(seg:UIStoryboardSegue) {
        println("I \(self) was asked to unwind \(seg) \(seg.identifier)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println("I \(self) was asked to prepare for segue \(segue) \(segue.identifier)")
    }
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        let ok = super.respondsToSelector(aSelector)
        if NSStringFromSelector(aSelector) == "unwind:" {
            println("I \(self) was asked responds to selector \(aSelector), responding \(ok)")
        }
        return ok
    }
    
    
}