
import UIKit

class ViewController : UIViewController {
    var blackRectConstraintsOnscreen : [NSLayoutConstraint]!
    var blackRectConstraintsOffscreen : [NSLayoutConstraint]!
    
    override func viewDidLoad() {
        let br = UIView()
        br.setTranslatesAutoresizingMaskIntoConstraints(false)
        br.backgroundColor = UIColor.blackColor()
        self.view.addSubview(br)
        // not needed if we're already doing autolayout
        // [self.view setNeedsUpdateConstraints];
        
        // "b.r. is pinned to top and bottom of superview"
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:|[br]|",
                options:nil, metrics:nil, views:["br":br]))
        
        // "b.r. is 1/3 the width of superview"
        self.view.addConstraint(
            NSLayoutConstraint(item:br, attribute:.Width,
                relatedBy:.Equal,
                toItem:self.view, attribute:.Width,
                multiplier:1.0/3.0, constant:0))
        
        // "onscreen, b.r.'s left is pinned to superview's left"
        let marrOn =
        NSLayoutConstraint.constraintsWithVisualFormat("H:|[br]",
            options:nil, metrics:nil, views:["br":br])
        
        // "offscreen, b.r.'s right is pinned to superview's left"
        let marrOff = [
            NSLayoutConstraint(item:br, attribute:.Right,
                relatedBy:.Equal,
                toItem:self.view, attribute:.Left,
                multiplier:1, constant:0)
        ]
        
        self.blackRectConstraintsOnscreen = marrOn as! [NSLayoutConstraint]
        self.blackRectConstraintsOffscreen = marrOff
        // start out offscreen!
        self.view.addConstraints(self.blackRectConstraintsOffscreen)
        
    }
    
    // old code
    /*
    override func updateViewConstraints() {
        self.view.removeConstraints(self.blackRectConstraintsOnscreen)
        self.view.removeConstraints(self.blackRectConstraintsOffscreen)
        if self.traitCollection.verticalSizeClass == .Compact {
            self.view.addConstraints(self.blackRectConstraintsOnscreen)
        } else {
            self.view.addConstraints(self.blackRectConstraintsOffscreen)
        }
        super.updateViewConstraints()
    }
*/
    
    // iOS 8 gives us a more appropriate place to do that
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        self.view.removeConstraints(self.blackRectConstraintsOnscreen)
        self.view.removeConstraints(self.blackRectConstraintsOffscreen)
        if newCollection.verticalSizeClass == .Compact {
            self.view.addConstraints(self.blackRectConstraintsOnscreen)
        } else {
            self.view.addConstraints(self.blackRectConstraintsOffscreen)
        }

    }
}
