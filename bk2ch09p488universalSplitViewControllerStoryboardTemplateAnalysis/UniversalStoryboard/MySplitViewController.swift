

import UIKit

class MySplitViewController: UISplitViewController {
    
    override func targetViewControllerForAction(action: Selector, sender: AnyObject?) -> UIViewController? {
        print("split view controller target for \(action) \(sender)...")
        let result = super.targetViewControllerForAction(action, sender: sender)
        print("split view controller target for \(action), returning \(result)")
        return result
    }
    
    override func showDetailViewController(vc: UIViewController, sender: AnyObject?) {
        print("split view controller showDetailViewController")
        super.showDetailViewController(vc, sender: sender)
    }
    
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        let vc = super.childViewControllerForStatusBarHidden()
        print("hidden: \(vc)")
        return vc
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        let vc = super.childViewControllerForStatusBarStyle()
        print("style: \(vc)")
        return vc
    }


    override func respondsToSelector(aSelector: Selector) -> Bool {
        let ok = super.respondsToSelector(aSelector)
        if aSelector == "showDetailViewController:sender:" {
            print("svc responds? \(ok)")
        }
        return ok
    }

    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        let ok = super.canPerformAction(action, withSender:sender)
        if action == "showDetailViewController:sender:" {
            print("svc can perform? \(ok)")
        }
        return ok
    }

   
}
