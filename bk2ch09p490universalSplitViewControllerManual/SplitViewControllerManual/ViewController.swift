

import UIKit

/*
A completely silly example (I doubt you'd really use a split view controller for this interface,
or that you'd even want this interface) - but it shows succinctly how to configure _manually_
a split view controller for use in both iPad and iPhone
*/

// create and configure split view controller entirely in code, place into interface

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        let svc = UISplitViewController()
        svc.viewControllers = [PrimaryViewController(), SecondaryViewController()]
        self.addChildViewController(svc)
        self.view.addSubview(svc.view)
        svc.didMoveToParentViewController(self)
        
        svc.presentsWithGesture = false
        svc.preferredDisplayMode = .PrimaryHidden
    }
    
    // demonstration of how to implement your own logic for targetViewControllerForAction
    // here, we arrange things so that the showHide: message, if it reaches this far the hierarchy,
    // is routed to the Primary view controller if possible
    // In this way, the Secondary can message the Primary completely agnostically!
    // This is the kind of "loose coupling" that Apple is after here
    
    override func targetViewControllerForAction(action: Selector, sender: AnyObject?) -> UIViewController? {
        if action == "showHide:" {
            let svc = self.childViewControllers[0] as! UISplitViewController
            let primary = svc.viewControllers[0] 
            if primary.canPerformAction(action, withSender: sender) {
                return primary
            }
        }
        return super.targetViewControllerForAction(action, sender: sender)
    }
    
}

