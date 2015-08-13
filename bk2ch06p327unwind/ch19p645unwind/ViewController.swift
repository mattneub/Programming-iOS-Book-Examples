

import UIKit

class ViewController : UIViewController {
    
    
    @IBAction func unwind(seg:UIStoryboardSegue!) {
        print("view controller 1 unwind is called")
    }

    override func respondsToSelector(aSelector: Selector) -> Bool {
        if NSStringFromSelector(aSelector) == "unwind:" {
            print("\(self) is asked if it responds to \(aSelector)")
        }
        let result = super.respondsToSelector(aSelector)
        return result
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        
        print("view controller 1 can perform returns \(result)")
        return result
    }


    override func allowedChildViewControllersForUnwindingFromSource(source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        print("view controller 1 allowed child vcs called...")
        let vcs = super.allowedChildViewControllersForUnwindingFromSource(source)
        print("view controller 1 the source was \(source.sourceViewController) sent by \(source.sender)")
        print("view controller 1 returns \(vcs) from allowed child vcs")
        return vcs
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("view controller 1 was told to unwind for segue")
        super.unwindForSegue(unwindSegue, towardsViewController: subsequentVC)
    }


}
