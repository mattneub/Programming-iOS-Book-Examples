

import UIKit

class ViewController : UIViewController {
    
    // play with this both in iOS 8 and iOS 7 to see how things have changed
    
    @IBOutlet var lab : UILabel!
    
    override var description : String {
        get {
            if self.lab != nil {
                return "View Controller \(self.lab.text!)"
            }
            else {
                return super.description
            }
        }
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        println("I \(self) will be asked can perform from \(fromViewController)")
        let ok = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        println("I \(self) was asked can perform from \(fromViewController), and I am answering \(ok)")
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
        if (NSStringFromSelector(aSelector) as NSString).rangeOfString("Unwind").length > 0 {
            println("I \(self) was asked responds to selector \(aSelector), responding \(ok)")
        }
        return ok
    }

    
}