

import UIKit

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // our nib uses autolayout...
        // ... but we intend to animate v, so we take it out of autolayout
        self.v.translatesAutoresizingMaskIntoConstraints = true
        // (and v's constraints in the nib are all placeholders, so they've been deleted)
    }
    
    @IBAction func doButton(_ sender: Any?) {
        UIView.animate(withDuration:1, animations: {
            self.v.center.x += 100
            }, completion: {
                _ in
                UIView.animate(withDuration:0.3, delay: 0, options: .autoreverse,
                    animations: {
                        self.v.transform = CGAffineTransform(scaleX:1.1, y:1.1)
                    }, completion: {
                        _ in
                        self.v.transform = .identity
                        self.v.superview!.setNeedsLayout()
                        self.v.superview!.layoutIfNeeded() // no violation of constraints
                    })
            })
    }
}
