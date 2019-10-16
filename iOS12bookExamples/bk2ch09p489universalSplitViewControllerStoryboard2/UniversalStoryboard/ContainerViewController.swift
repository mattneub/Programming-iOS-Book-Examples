
import UIKit

// you can't use any delegate method to prevent collapse from occurring at all
// to do that - e.g., to prevent collapse on iPhone -
// you need to prevent the split view controller from trying to adapt
// simplest way is to wrap the split view controller in your own container v.c....
// and override the child traits so that the s.v.c. never hears that it is on a smaller device

class ContainerViewController : UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    override func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        if let svc = self.children[0] as? UISplitViewController {
            svc.delegate = self // need to do this as early as humanly possible
        }
    }
        
    // as in comedy, timing is everything
    // this setup needs to be postponed to our initial layout (viewDidLoad is too soon)
    
    let which = 1 // try 2, it's even more interesting
    
    var didInitialSetup = false
    override func viewWillLayoutSubviews() {
        if !self.didInitialSetup {
            self.didInitialSetup = true
            self.view.backgroundColor = .green
            let svc = self.children[0] as! UISplitViewController
            svc.preferredDisplayMode = .allVisible
            // if not collapsed, always side by side
            // if you insert the display mode button, it gives the option to hide the master column
            // using a new icon which currently looks like the "fullscreen" icon
            
            svc.preferredPrimaryColumnWidthFraction = 0.5 // this works only if also give permission...
            svc.maximumPrimaryColumnWidth = 500 // ...by setting this to a large enough value
            
            // this is why we are here: we can prevent collapse entirely
            if which == 1 {
                let traits = UITraitCollection(traitsFrom: [
                    UITraitCollection(horizontalSizeClass: .regular)
                    ])
                self.setOverrideTraitCollection(traits, forChild: svc)
            }

        }
    }
    
    // another variant (see Apple's AdaptivePhotos example):
    // don't override traits on launch (so, portrait, collapsed)
    // but do override just in case we rotate to landscape
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let svc = self.children[0] as! UISplitViewController
        if which == 2 {
            if size.width > size.height {
                // landscape
                let traits = UITraitCollection(traitsFrom: [
                    UITraitCollection(horizontalSizeClass: .regular)
                    ])
                self.setOverrideTraitCollection(traits, forChild: svc)
            } else {
                self.setOverrideTraitCollection(nil, forChild: svc)
            }
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension ContainerViewController : UISplitViewControllerDelegate {
    // as in the template, we must take action to prevent the detail from being pushed and shown
    // in collapsed mode
    
    func splitViewController(_ svc: UISplitViewController,
        collapseSecondary vc2: UIViewController,
        onto vc1: UIViewController) -> Bool {
            return true
    }

    
}
