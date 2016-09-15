

import UIKit

class ViewController : UIViewController {
    @IBOutlet var randomLabel : UILabel!
    @IBOutlet var sectionHeightConstraint : NSLayoutConstraint!
    @IBOutlet var bottomInternalConstraint : NSLayoutConstraint!
    var collapsed = false
    let texts = ["This text can expand and collapse", "The quick brown fox jumps over the lazy dog. Then he went on vacation... Then he had a drink..."]
    var long = false
    
    @IBAction func toggleContents(sender: AnyObject!) {
        self.long = !self.long
        self.randomLabel.text = self.texts[self.long ? 1 : 0]
        UIView.animateWithDuration(1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func toggleButtonSelector (sender:AnyObject!) {
        self.collapsed = !self.collapsed
        if self.collapsed {
            self.sectionHeightConstraint.constant = 10
            self.sectionHeightConstraint.priority = 999
            NSLayoutConstraint.deactivateConstraints([self.bottomInternalConstraint])
            UIView.animateWithDuration(1) {
                self.view.layoutIfNeeded()
            }
            
        } else {
            self.sectionHeightConstraint.priority = 250
            NSLayoutConstraint.activateConstraints([self.bottomInternalConstraint])
            UIView.animateWithDuration(1) {
                self.view.layoutIfNeeded()
            }
        }
    }

}
