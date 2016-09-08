
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var oldConstraint: NSLayoutConstraint!
    
    // show that you can animate more than a change of constant
    // here, I remove one constraint and replace it with another - and I can still animate layout!
    // (I am told you can also animate change of priority, but you can't change from 1000)
    
    @IBAction func doButton(_ sender: Any) {
        let v = sender as! UIView
        let c = self.oldConstraint.constant
        NSLayoutConstraint.deactivate([self.oldConstraint])
        let newConstraint = c > 0 ?
            v.trailingAnchor.constraint(equalTo:self.view.layoutMarginsGuide.trailingAnchor, constant:-c) :
            v.leadingAnchor.constraint(equalTo:self.view.layoutMarginsGuide.leadingAnchor, constant:-c)
        NSLayoutConstraint.activate([newConstraint])
        self.oldConstraint = newConstraint
        UIView.animate(withDuration:0.4) {
            v.superview!.layoutIfNeeded()
        }
    }
    
    
}

