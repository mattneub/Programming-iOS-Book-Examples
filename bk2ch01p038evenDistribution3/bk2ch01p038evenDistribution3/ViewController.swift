

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var views : [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainview = self.view
        
        // do manually what UIStackView does: make distributing UILayoutGuide objects
        
        let guides = [UILayoutGuide(), UILayoutGuide(), UILayoutGuide()]
        for guide in guides {
            mainview.addLayoutGuide(guide)
        }
        NSLayoutConstraint.activateConstraints([
            // guide left is arbitrary, let's say superview margin
            guides[0].leadingAnchor.constraintEqualToAnchor(mainview.leadingAnchor),
            guides[1].leadingAnchor.constraintEqualToAnchor(mainview.leadingAnchor),
            guides[2].leadingAnchor.constraintEqualToAnchor(mainview.leadingAnchor),
            // guide widths are arbitrary, let's say 10
            guides[0].widthAnchor.constraintEqualToConstant(10),
            guides[1].widthAnchor.constraintEqualToConstant(10),
            guides[2].widthAnchor.constraintEqualToConstant(10),
            // bottom of each view is top of following guide
            views[0].bottomAnchor.constraintEqualToAnchor(guides[0].topAnchor),
            views[1].bottomAnchor.constraintEqualToAnchor(guides[1].topAnchor),
            views[2].bottomAnchor.constraintEqualToAnchor(guides[2].topAnchor),
            // top of each view is bottom of preceding guide
            views[1].topAnchor.constraintEqualToAnchor(guides[0].bottomAnchor),
            views[2].topAnchor.constraintEqualToAnchor(guides[1].bottomAnchor),
            views[3].topAnchor.constraintEqualToAnchor(guides[2].bottomAnchor),
            // guide heights are equal!
            guides[1].heightAnchor.constraintEqualToAnchor(guides[0].heightAnchor),
            guides[2].heightAnchor.constraintEqualToAnchor(guides[0].heightAnchor),
        ])
        
        // isn't it spooooky, possums?
        

    
    }



}

