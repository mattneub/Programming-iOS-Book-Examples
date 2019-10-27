

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var views : [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // do manually what UIStackView does: make distributing UILayoutGuide objects
        
        var guides = [UILayoutGuide]()
        // one fewer guides than views
        for _ in views.dropLast() {
            let g = UILayoutGuide()
            self.view.addLayoutGuide(g)
            guides.append(g)
        }
        // guides leading and width are arbitrary
        let anc = self.view.leadingAnchor
        for g in guides {
            g.leadingAnchor.constraint(equalTo:anc).isActive = true
            g.widthAnchor.constraint(equalToConstant:10).isActive = true
        }
        // guides top to previous view
        for (v,g) in zip(views.dropLast(), guides) {
            v.bottomAnchor.constraint(equalTo:g.topAnchor).isActive = true
        }
        // guides bottom to next view
        for (v,g) in zip(views.dropFirst(), guides) {
            v.topAnchor.constraint(equalTo:g.bottomAnchor).isActive = true
        }
        // guide heights equal to each other!
        let h = guides[0].heightAnchor
        for g in guides.dropFirst() {
            g.heightAnchor.constraint(equalTo:h).isActive = true
        }
        
        /*
        let guides = [UILayoutGuide(), UILayoutGuide(), UILayoutGuide()]
        for guide in guides {
            self.view.addLayoutGuide(guide)
        }
 */
        /*
        NSLayoutConstraint.activate([
            // guide left is arbitrary, let's say superview margin
            guides[0].leadingAnchor.constraint(equalTo:self.view.leadingAnchor),
            guides[1].leadingAnchor.constraint(equalTo:self.view.leadingAnchor),
            guides[2].leadingAnchor.constraint(equalTo:self.view.leadingAnchor),
            // guide widths are arbitrary, let's say 10
            guides[0].widthAnchor.constraint(equalToConstant:10),
            guides[1].widthAnchor.constraint(equalToConstant:10),
            guides[2].widthAnchor.constraint(equalToConstant:10),
            // bottom of each view is top of following guide
            views[0].bottomAnchor.constraint(equalTo:guides[0].topAnchor),
            views[1].bottomAnchor.constraint(equalTo:guides[1].topAnchor),
            views[2].bottomAnchor.constraint(equalTo:guides[2].topAnchor),
            // top of each view is bottom of preceding guide
            views[1].topAnchor.constraint(equalTo:guides[0].bottomAnchor),
            views[2].topAnchor.constraint(equalTo:guides[1].bottomAnchor),
            views[3].topAnchor.constraint(equalTo:guides[2].bottomAnchor),
            // guide heights are equal!
            guides[1].heightAnchor.constraint(equalTo:guides[0].heightAnchor),
            guides[2].heightAnchor.constraint(equalTo:guides[0].heightAnchor),
        ])
 */
        
        // isn't it spooooky, possums?
        

    
    }



}

