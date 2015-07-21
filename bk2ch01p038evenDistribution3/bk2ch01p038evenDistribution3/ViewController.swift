

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var views : [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // do manually what UIStackView does: make distributing UILayoutGuide objects
        
        let guides = [UILayoutGuide(), UILayoutGuide(), UILayoutGuide()]
        for guide in guides {
            self.view.addLayoutGuide(guide)
        }
        NSLayoutConstraint.activateConstraints([
            // guide heights are equal
            guides[1].heightAnchor.constraintEqualToAnchor(guides[0].heightAnchor),
            guides[2].heightAnchor.constraintEqualToAnchor(guides[0].heightAnchor),
            // guide widths are arbitrary, let's say 10
            guides[0].widthAnchor.constraintEqualToConstant(10),
            guides[1].widthAnchor.constraintEqualToConstant(10),
            guides[2].widthAnchor.constraintEqualToConstant(10),
            // guide left is arbitrary, let's say superview margin
            guides[0].leftAnchor.constraintEqualToAnchor(self.view.leftAnchor),
            guides[1].leftAnchor.constraintEqualToAnchor(self.view.leftAnchor),
            guides[2].leftAnchor.constraintEqualToAnchor(self.view.leftAnchor),
            // bottom of each view is top of following guide
            views[0].bottomAnchor.constraintEqualToAnchor(guides[0].topAnchor),
            views[1].bottomAnchor.constraintEqualToAnchor(guides[1].topAnchor),
            views[2].bottomAnchor.constraintEqualToAnchor(guides[2].topAnchor),
            // top of each view is bottom of preceding guide
            views[1].topAnchor.constraintEqualToAnchor(guides[0].bottomAnchor),
            views[2].topAnchor.constraintEqualToAnchor(guides[1].bottomAnchor),
            views[3].topAnchor.constraintEqualToAnchor(guides[2].bottomAnchor)
        ])
        
        // isn't it spooooky, possums?
        

    
    }



}

