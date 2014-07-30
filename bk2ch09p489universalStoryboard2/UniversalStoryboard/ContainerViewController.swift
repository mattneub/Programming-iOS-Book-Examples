
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
    
    override func viewWillLayoutSubviews() {
        if !self.didInitialSetup {
            self.didInitialSetup = true
            self.view.backgroundColor = UIColor.greenColor()
            let svc = self.childViewControllers[0] as UISplitViewController
            let traits = UITraitCollection(traitsFromCollections: [
                UITraitCollection(horizontalSizeClass: .Regular),
                UITraitCollection(verticalSizeClass: .Regular)
                ])
            self.setOverrideTraitCollection(traits, forChildViewController: svc)
            
            svc.preferredDisplayMode = .AllVisible
            // if not collapsed, always side by side
            // if you insert the display mode button, it gives the option to hide the master column
            // using a new icon which currently looks like the "fullscreen" icon
            
            svc.preferredPrimaryColumnWidthFraction = 0.5 // this works only if also give permission...
            svc.maximumPrimaryColumnWidth = 500 // ...by setting this to a large enough value
        }
    }
    
    
}
