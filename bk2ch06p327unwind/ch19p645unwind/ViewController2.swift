

import UIKit

class ViewController2 : UIViewController {
    
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        if NSStringFromSelector(aSelector) == "unwind:" {
            print("view controller 2 is asked if it responds to \(aSelector)")
        }
        let result = super.respondsToSelector(aSelector)
        return result
    }

    override func allowedChildViewControllersForUnwindingFromSource(source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        print("view controller 2 allowed child vcs called...")
        let vcs = super.allowedChildViewControllersForUnwindingFromSource(source)
        print("view controller 2 the source was \(source.sourceViewController) sent by \(source.sender)")
        print("view controller 2 returns \(vcs) from allowed child vcs")
        return vcs
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("view controller 2 was told to unwind for segue")
        super.unwindForSegue(unwindSegue, towardsViewController: subsequentVC)
    }

    @IBAction func unwindNOT(seg:UIStoryboardSegue!) {
        print("view controller 2 unwind is called")
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        print("view controller 2 can perform returns \(result)")
        return result
    }

    
    /*
    
    let which = 2

    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        var result = false
        
        switch which {
        case 1:
            result = true
        case 2:
            result = false
        default: break
        }
        
        print("view controller 2 can perform returns \(result)")
        return result
    }

*/


}
