
import UIKit

class ViewController3 : UIViewController {
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        if NSStringFromSelector(aSelector) == "unwind:" {
            print("\(self) is asked if it responds to \(aSelector)")
        }
        let result = super.respondsToSelector(aSelector)
        return result
    }

    override func allowedChildViewControllersForUnwindingFromSource(source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        print("view controller 3 allowed child vcs called...")
        let vcs = super.allowedChildViewControllersForUnwindingFromSource(source)
        print("view controller 3 the source was \(source.sourceViewController) sent by \(source.sender)")
        print("view controller 3 returns \(vcs) from allowed child vcs")
        return vcs
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("view controller 3 was told to unwind for segue")
        super.unwindForSegue(unwindSegue, towardsViewController: subsequentVC)
    }

    
    @IBAction func unwind(seg:UIStoryboardSegue!) {
        fatalError("view controller 3 unwind should never be called")
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        print("view controller 3 can perform returns \(result)")
        return result
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
        print("view controller 3 should perform returns \(result)")
        return result
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        print("view controller 3 prepare for segue is called")
    }

}
