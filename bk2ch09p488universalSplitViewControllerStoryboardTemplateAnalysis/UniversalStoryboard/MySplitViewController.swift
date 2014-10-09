

import UIKit

class MySplitViewController: UISplitViewController {
    
    override func targetViewControllerForAction(action: Selector, sender: AnyObject?) -> UIViewController? {
        println("split view controller target for \(action)...")
        let result = super.targetViewControllerForAction(action, sender: sender)
        println("split view controller target for \(action), returning \(result)")
        return result
    }
    
    override func showDetailViewController(vc: UIViewController!, sender: AnyObject!) {
        println("split view controller showDetailViewController")
        super.showDetailViewController(vc, sender: sender)
    }
    
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        let vc = super.childViewControllerForStatusBarHidden()
        println("hidden: \(vc)")
        return vc
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        let vc = super.childViewControllerForStatusBarStyle()
        println("style: \(vc)")
        return vc
    }



   
}
