

import UIKit

class MySplitViewController: UISplitViewController {
    
    override func targetViewController(forAction action: Selector, sender: Any?) -> UIViewController? {
        print("split view controller target for \(action) \(sender as Any)...")
        let result = super.targetViewController(forAction: action, sender: sender)
        print("split view controller target for \(action), returning \(result as Any)")
        return result
    }
    
    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        print("split view controller showDetailViewController")
        super.showDetailViewController(vc, sender: sender)
    }
    
    override var childForStatusBarHidden : UIViewController? {
        let vc = super.childForStatusBarHidden
        print("hidden: \(vc as Any)")
        return vc
    }
    
    override var childForStatusBarStyle : UIViewController? {
        let vc = super.childForStatusBarStyle
        print("style: \(vc as Any)")
        return vc
    }


    override func responds(to aSelector: Selector) -> Bool {
        let ok = super.responds(to:aSelector)
        if aSelector == #selector(showDetailViewController) {
            print("svc responds? \(ok)")
        }
        return ok
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        let ok = super.canPerformAction(action, withSender:sender)
        if action == #selector(showDetailViewController) {
            print("svc can perform? \(ok)")
        }
        return ok
    }

   
}
