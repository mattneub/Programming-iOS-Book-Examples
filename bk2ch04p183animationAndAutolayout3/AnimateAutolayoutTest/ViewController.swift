
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var oldConstraint: NSLayoutConstraint!
    
    // show that you can animate more than a change of constant
    // here, I remove one constraint and replace it with another - and I can still animate layout!
    // (I am told you can also animate change of priority, but you can't change from 1000)
    
    @IBAction func doButton(sender: AnyObject) {
        let v = sender as! UIView
        let c = self.oldConstraint.constant
        NSLayoutConstraint.deactivateConstraints([self.oldConstraint])
        let newConstraint = c > 0 ?
            NSLayoutConstraint(item: v, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .TrailingMargin, multiplier: 1, constant: -c) :
            NSLayoutConstraint(item: v, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: -c)
        NSLayoutConstraint.activateConstraints([newConstraint])
        self.oldConstraint = newConstraint
        UIView.animateWithDuration(0.4) {
            v.layoutIfNeeded()
        }
    }


}

