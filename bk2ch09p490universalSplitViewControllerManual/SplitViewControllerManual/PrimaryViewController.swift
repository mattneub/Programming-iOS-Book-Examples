

import UIKit

/*
In expanded view (e.g. iPad), the Primary will appear on the left or can slide out of sight,
and the Secondary will be managed by the split view controller and will appear on the right
or alone.

In collapsed view (e.g. iPhone), the Primary will appear and must function as a container v.c.,
and must take sole charge of the Secondary. The split view controller is essentially doing nothing
(it's just a neutral container for the Primary, which does all the work).

For this extremely artificial example, I've used an interface where, in collapsed view,
the Primary view just contains the Secondary view directly. It's silly but I think it's
clearer than the standard navigation interface, which distracts from what's really happening.
*/

class PrimaryViewController : UIViewController {
    
    var verticalConstraints : [NSLayoutConstraint]?
    var exposed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure our view
        self.view.backgroundColor = UIColor.greenColor()
        let seg = UISegmentedControl(items: ["White","Red"])
        seg.selectedSegmentIndex = 1
        self.view.addSubview(seg)
        seg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            seg.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor),
            seg.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant:-50)
        ])
        seg.addTarget(self, action: "change:", forControlEvents: .ValueChanged)
    }
    
    func change(sender:AnyObject) {
        var vc : UIViewController
        // note this expression of the difference as to where the Secondary will be,
        // depending whether the svc is expanded or collapsed
        if !self.splitViewController!.collapsed {
            vc = self.splitViewController!.viewControllers[1] 
        } else {
            vc = self.childViewControllers[0] 
        }
        let seg = sender as! UISegmentedControl
        switch seg.selectedSegmentIndex {
        case 0:
            vc.view.backgroundColor = UIColor.whiteColor()
        case 1:
            vc.view.backgroundColor = UIColor.redColor()
        default:break
        }
    }
    
    // change from expanded to collapsed; we, as Primary, are consulted automatically
    // our job is to accept the Secondary, which will be removed from the svc's children array,
    // and do something with it; we are now its sole owner and proprietor
    // in this example, I make the Secondary the Primary's child and cover the interface with its view
    
    // if this were an interface where collapsed could turn to expanded,
    // we would also need to implement the inverse operation
    
    override func collapseSecondaryViewController(vc2: UIViewController, forSplitViewController splitViewController: UISplitViewController) {
        self.addChildViewController(vc2)
        self.view.addSubview(vc2.view)
        vc2.didMoveToParentViewController(self)
        
        vc2.view.translatesAutoresizingMaskIntoConstraints = false
        self.verticalConstraints =
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|", options: [], metrics: nil, views: ["v":vc2.view])
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[v]|", options: [], metrics: nil, views: ["v":vc2.view]),
            self.verticalConstraints!
        ].flatten().map{$0})
    }
}

// I illustrate how targetViewControllerForAction can be used...
// ...so that the secondary can find the primary in an agnostic way

// to use targetViewControllerForAction for a custom action, 
// you need an extension to satisfy the compiler

extension UIViewController {
    func showHide(sender:AnyObject?) {
        // how to use targetViewControllerForAction to look up the hierarchy
        // we don't know who implements showHide or where he is in the hierarchy,
        // and we don't care! agnostic messaging up the hierarchy
        let target = self.targetViewControllerForAction("showHide:", sender: sender)
        if target != nil {
            target!.showHide(self)
        }
    }
}


// ...and then override to implement in a specific class ...
// ... so that targetViewControllerForAction finds this specific instance

extension PrimaryViewController {
    
    override func showHide(sender:AnyObject?) {
        print("showHide")
        // how to show/hide ourselves depends on the state of the split view controller
        // if expanded, let the split view controller deal with it
        // if collapsed, we are in charge of the interface and must decide what this means
        
        let svc = self.splitViewController!
        if !svc.collapsed {
            switch svc.displayMode {
            case .PrimaryHidden:
                // changing display mode is animatable!
                UIView.animateWithDuration(0.2, animations: {
                    svc.preferredDisplayMode = .PrimaryOverlay
                    })
            default:
                svc.preferredDisplayMode = .Automatic
            }
        }
        else {
            let vc2 = sender as! UIViewController
            var con = 0
            if !self.exposed {
                con = 270
            }
            self.exposed = !self.exposed
            self.view.removeConstraints(self.verticalConstraints!)
            self.verticalConstraints =
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-(minuscon)-[v]-(con)-|", options: [], metrics: ["con":con, "minuscon":-con], views: ["v":vc2.view])
            NSLayoutConstraint.activateConstraints(self.verticalConstraints!)
            UIView.animateWithDuration(0.25, animations: {
                self.view.layoutIfNeeded()
                })
        }
    }
}
