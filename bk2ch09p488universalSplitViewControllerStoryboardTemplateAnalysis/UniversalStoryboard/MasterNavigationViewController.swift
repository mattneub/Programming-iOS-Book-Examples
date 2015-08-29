

import UIKit
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class MasterNavigationViewController : UINavigationController {
    // logging to show how things work
    // the segue sends showDetailViewController
    // by way of "target for"
    // the split view controller implements it, it gets the call...
    
    // when it is expanded, it just shoves the detail view controller into the detail slot
    // but when it is collapsed,
    // it turns around and sends showViewController to the nav controller in the primary!
    // thus it gets pushed onto the stack
    
    override func showViewController(vc: UIViewController, sender: AnyObject?) {
        print("master NAV view controller showViewController: \(vc)")
        super.showViewController(vc, sender: sender)
        delay(1) {
            print(self.viewControllers)
        }
    }
    
    override func targetViewControllerForAction(action: Selector, sender: AnyObject?) -> UIViewController? {
        print("master NAV view controller target for \(action) \(sender)...")
        let result = super.targetViewControllerForAction(action, sender: sender)
        print("master NAV view controller target for \(action), returning \(result)")
        return result
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true // no effect
    }
    
    override func respondsToSelector(aSelector: Selector) -> Bool {
        let ok = super.respondsToSelector(aSelector)
        if aSelector == "showDetailViewController:sender:" {
            print("master NAV responds? \(ok)")
        }
        return ok
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        let ok = super.canPerformAction(action, withSender:sender)
        if action == "showDetailViewController:sender:" {
            print("master NAV can perform? \(ok)")
        }
        return ok
    }




}
