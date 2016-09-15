
import UIKit

class ViewController : UIViewController {
    var greenRectConstraintsOnscreen : [NSLayoutConstraint]!
    var greenRectConstraintsOffscreen : [NSLayoutConstraint]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gr = UIView()
        gr.translatesAutoresizingMaskIntoConstraints = false
        gr.backgroundColor = UIColor.greenColor()
        self.view.addSubview(gr)
        // not needed if we're already doing autolayout
        // [self.view setNeedsUpdateConstraints];
        
        var c = [NSLayoutConstraint]()
        // "g.r. is pinned to top and bottom of superview"
        c.appendContentsOf(
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[gr]|",
                options:[], metrics:nil, views:["gr":gr])
        )
        // "g.r. is 1/3 the width of superview"
        c.append(
            gr.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 1.0/3.0)
        )
        
        // "onscreen, g.r.'s left is pinned to superview's left"
        let marrOn : [NSLayoutConstraint] =
        NSLayoutConstraint.constraintsWithVisualFormat("H:|[gr]",
            options:[], metrics:nil, views:["gr":gr])
        
        // "offscreen, g.r.'s right is pinned to superview's left"
        let marrOff : [NSLayoutConstraint] = [
            gr.trailingAnchor.constraintEqualToAnchor(self.view.leadingAnchor)
        ]
        
        self.greenRectConstraintsOnscreen = marrOn
        self.greenRectConstraintsOffscreen = marrOff
        // start out offscreen!
        c.appendContentsOf(marrOff)
        NSLayoutConstraint.activateConstraints(c)
        self.adjustInterfaceForSize(self.view.bounds.size)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        if size != self.view.bounds.size {
            self.adjustInterfaceForSize(size)
        }
    }
    
    func adjustInterfaceForSize(size: CGSize) {
        NSLayoutConstraint.deactivateConstraints(self.greenRectConstraintsOnscreen)
        NSLayoutConstraint.deactivateConstraints(self.greenRectConstraintsOffscreen)
        if size.width > size.height {
            NSLayoutConstraint.activateConstraints(self.greenRectConstraintsOnscreen)
        } else {
            NSLayoutConstraint.activateConstraints(self.greenRectConstraintsOffscreen)
        }
    }
    
    
    // iOS 8 gives us a more appropriate place to do that
    
}
