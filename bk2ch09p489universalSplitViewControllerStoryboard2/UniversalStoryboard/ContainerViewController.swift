
import UIKit

// you can't use any delegate method to prevent collapse from occurring at all
// to do that - e.g., to prevent collapse on iPhone -
// you need to prevent the split view controller from trying to adapt
// simplest way is to wrap the split view controller in your own container v.c....
// and override the child traits so that the s.v.c. never hears that it is on a smaller device

class ContainerViewController : UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    var didInitialSetup = false
    
    override func addChildViewController(childController: UIViewController) {
        super.addChildViewController(childController)
        if let svc = self.childViewControllers[0] as? UISplitViewController {
            svc.delegate = self // need to do this as early as humanly possible
        }
    }
    
    // unfortunately, IB will not let us make a constraint to the top of the superview
    // it insists on making the constraint to the bottom of the top layout guide
    // so we take control of the situation by swapping out constraints in code at launch
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.removeConstraint(self.topConstraint)
        self.view.addConstraint(
            NSLayoutConstraint(item: self.containerView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0)
        )
    }
    
    // as in comedy, timing is everything
    // this setup needs to be postponed to our initial layout (viewDidLoad is too soon)
    
    let which = 1 // try 2, it's even more interesting
    
    override func viewWillLayoutSubviews() {
        if !self.didInitialSetup {
            self.didInitialSetup = true
            self.view.backgroundColor = UIColor.greenColor()
            let svc = self.childViewControllers[0] as! UISplitViewController
            svc.preferredDisplayMode = .AllVisible
            // if not collapsed, always side by side
            // if you insert the display mode button, it gives the option to hide the master column
            // using a new icon which currently looks like the "fullscreen" icon
            
            svc.preferredPrimaryColumnWidthFraction = 0.5 // this works only if also give permission...
            svc.maximumPrimaryColumnWidth = 500 // ...by setting this to a large enough value
            
            // this is why we are here: we can prevent collapse entirely
            if which == 1 {
                let traits = UITraitCollection(traitsFromCollections: [
                    UITraitCollection(horizontalSizeClass: .Regular)
                    ])
                self.setOverrideTraitCollection(traits, forChildViewController: svc)
            }

        }
    }
    
    // another variant (see Apple's AdaptivePhotos example):
    // don't override traits on launch (so, portrait, collapsed)
    // but do override just in case we rotate to landscape
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let svc = self.childViewControllers[0] as! UISplitViewController
        if which == 2 {
            if size.width > 320 {
                // landscape
                let traits = UITraitCollection(traitsFromCollections: [
                    UITraitCollection(horizontalSizeClass: .Regular)
                    ])
                self.setOverrideTraitCollection(traits, forChildViewController: svc)
            } else {
                self.setOverrideTraitCollection(nil, forChildViewController: svc)
            }
        }
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
}

extension ContainerViewController : UISplitViewControllerDelegate {
    // as in the template, we must take action to prevent the detail from being pushed and shown
    // in collapsed mode
    
    func splitViewController(svc: UISplitViewController,
        collapseSecondaryViewController vc2: UIViewController!,
        ontoPrimaryViewController vc1: UIViewController!) -> Bool {
            return true
    }

    
}
