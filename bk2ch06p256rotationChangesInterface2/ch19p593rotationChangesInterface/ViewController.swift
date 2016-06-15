
import UIKit

class ViewController : UIViewController {
    var greenRectConstraintsOnscreen : [NSLayoutConstraint]!
    var greenRectConstraintsOffscreen : [NSLayoutConstraint]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gr = UIView()
        gr.translatesAutoresizingMaskIntoConstraints = false
        gr.backgroundColor = UIColor.green()
        self.view.addSubview(gr)
        // not needed if we're already doing autolayout
        // [self.view setNeedsUpdateConstraints];
        
        var c = [NSLayoutConstraint]()
        // "g.r. is pinned to top and bottom of superview"
        c.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat:"V:|[gr]|",
                metrics:nil, views:["gr":gr])
        )
        // "g.r. is 1/3 the width of superview"
        c.append(
            gr.widthAnchor.constraint(equalTo:self.view.widthAnchor, multiplier: 1.0/3.0)
        )
        
        // "onscreen, g.r.'s left is pinned to superview's left"
        let marrOn =
            NSLayoutConstraint.constraints(withVisualFormat:"H:|[gr]",
                metrics:nil, views:["gr":gr])
        
        // "offscreen, g.r.'s right is pinned to superview's left"
        let marrOff = [
            gr.trailingAnchor.constraint(equalTo:self.view.leadingAnchor)
        ]
        
        self.greenRectConstraintsOnscreen = marrOn
        self.greenRectConstraintsOffscreen = marrOff
        // start out offscreen!
        c.append(contentsOf:marrOff)
        NSLayoutConstraint.activate(c)
        
    }
    
    // old code
    /*
    override func updateViewConstraints() {
        self.view.removeConstraints(self.greenRectConstraintsOnscreen)
        self.view.removeConstraints(self.greenRectConstraintsOffscreen)
        if self.traitCollection.verticalSizeClass == .Compact {
            self.view.addConstraints(self.greenRectConstraintsOnscreen)
        } else {
            self.view.addConstraints(self.greenRectConstraintsOffscreen)
        }
        super.updateViewConstraints()
    }
*/
    
    // iOS 8 gives us a more appropriate place to do that
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to:newCollection, with: coordinator)
        NSLayoutConstraint.deactivate(self.greenRectConstraintsOnscreen)
        NSLayoutConstraint.deactivate(self.greenRectConstraintsOffscreen)
        if newCollection.verticalSizeClass == .compact {
            NSLayoutConstraint.activate(self.greenRectConstraintsOnscreen)
        } else {
            NSLayoutConstraint.activate(self.greenRectConstraintsOffscreen)
        }

    }
}
