

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var views : [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainview = self.view!
        
        // do manually what UIStackView does: make distributing UILayoutGuide objects
        
        let guides = [UILayoutGuide(), UILayoutGuide(), UILayoutGuide()]
        for guide in guides {
            mainview.addLayoutGuide(guide)
        }
        NSLayoutConstraint.activate([
            // guide left is arbitrary, let's say superview margin
            guides[0].leadingAnchor.constraintEqual(to:mainview.leadingAnchor),
            guides[1].leadingAnchor.constraintEqual(to:mainview.leadingAnchor),
            guides[2].leadingAnchor.constraintEqual(to:mainview.leadingAnchor),
            // guide widths are arbitrary, let's say 10
            guides[0].widthAnchor.constraintEqual(toConstant:10),
            guides[1].widthAnchor.constraintEqual(toConstant:10),
            guides[2].widthAnchor.constraintEqual(toConstant:10),
            // bottom of each view is top of following guide
            views[0].bottomAnchor.constraintEqual(to:guides[0].topAnchor),
            views[1].bottomAnchor.constraintEqual(to:guides[1].topAnchor),
            views[2].bottomAnchor.constraintEqual(to:guides[2].topAnchor),
            // top of each view is bottom of preceding guide
            views[1].topAnchor.constraintEqual(to:guides[0].bottomAnchor),
            views[2].topAnchor.constraintEqual(to:guides[1].bottomAnchor),
            views[3].topAnchor.constraintEqual(to:guides[2].bottomAnchor),
            // guide heights are equal!
            guides[1].heightAnchor.constraintEqual(to:guides[0].heightAnchor),
            guides[2].heightAnchor.constraintEqual(to:guides[0].heightAnchor),
        ])
        
        // isn't it spooooky, possums?
        

    
    }



}

