import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var v : UIView!
    
    @IBAction func doButton(sender : AnyObject?) {
        UIView.animateWithDuration(0.8, delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 20,
            options: nil,
            animations: {
                self.v.center.y += 100
            }, completion: nil)
    }
}
