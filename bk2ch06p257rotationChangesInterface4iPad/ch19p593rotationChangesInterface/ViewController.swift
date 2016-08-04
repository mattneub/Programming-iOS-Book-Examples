
import UIKit

class ViewController : UIViewController {
    var greenRectConstraintsOnscreen : [NSLayoutConstraint]!
    var greenRectConstraintsOffscreen : [NSLayoutConstraint]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gr = UIView()
        gr.translatesAutoresizingMaskIntoConstraints = false
        gr.backgroundColor = UIColor.green
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
        let marrOn : [NSLayoutConstraint] =
        NSLayoutConstraint.constraints(withVisualFormat:"H:|[gr]",
            metrics:nil, views:["gr":gr])
        
        // "offscreen, g.r.'s right is pinned to superview's left"
        let marrOff : [NSLayoutConstraint] = [
            gr.trailingAnchor.constraint(equalTo:self.view.leadingAnchor)
        ]
        
        self.greenRectConstraintsOnscreen = marrOn
        self.greenRectConstraintsOffscreen = marrOff
        // start out offscreen!
        c.append(contentsOf:marrOff)
        NSLayoutConstraint.activate(c)
        self.adjustInterface(for:self.view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with: coordinator)
        if size != self.view.bounds.size {
            self.adjustInterface(for:size)
        }
    }
    
    func adjustInterface(for size: CGSize) {
        NSLayoutConstraint.deactivate(self.greenRectConstraintsOnscreen)
        NSLayoutConstraint.deactivate(self.greenRectConstraintsOffscreen)
        if size.width > size.height {
            NSLayoutConstraint.activate(self.greenRectConstraintsOnscreen)
        } else {
            NSLayoutConstraint.activate(self.greenRectConstraintsOffscreen)
        }
    }
    
    
    // iOS 8 gives us a more appropriate place to do that
    
}
