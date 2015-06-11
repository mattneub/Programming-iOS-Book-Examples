

import UIKit

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // our nib uses autolayout...
        // ... but we intend to animate v, so we take it out of autolayout
        self.v.setTranslatesAutoresizingMaskIntoConstraints(true)
        // (and v's constraints in the nib are all placeholders, so they've been deleted)
    }
    
    @IBAction func doButton(sender:AnyObject?) {
        UIView.animateWithDuration(1, animations: {
            self.v.center.x += 100
            }, completion: {
                _ in
                UIView.animateWithDuration(0.3, delay: 0, options: .Autoreverse,
                    animations: {
                        self.v.transform = CGAffineTransformMakeScale(1.1, 1.1)
                    }, completion: {
                        _ in
                        self.v.transform = CGAffineTransformIdentity
                        self.v.layoutIfNeeded() // no violation of constraints
                    })
            })
    }
}
