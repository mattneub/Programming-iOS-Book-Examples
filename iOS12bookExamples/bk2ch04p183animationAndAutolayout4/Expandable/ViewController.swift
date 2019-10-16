

import UIKit

class ViewController : UIViewController {
    @IBOutlet var randomLabel : UILabel!
    @IBOutlet var sectionHeightConstraint : NSLayoutConstraint!
    @IBOutlet var bottomInternalConstraint : NSLayoutConstraint!
    var collapsed = false
    let texts = ["This text can expand and collapse", "The quick brown fox jumps over the lazy dog. Then he went on vacation... Then he had a drink..."]
    var long = false
    
    @IBAction func toggleContents(_ sender: Any!) {
        self.long.toggle()
        self.randomLabel.text = self.texts[self.long ? 1 : 0]
        UIView.animate(withDuration:1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func toggleButtonSelector (_ sender: Any!) {
        self.collapsed.toggle()
        if self.collapsed {
            self.sectionHeightConstraint.constant = 10
            self.sectionHeightConstraint.priority = UILayoutPriority(rawValue: 999)
            NSLayoutConstraint.deactivate([self.bottomInternalConstraint])
            UIView.animate(withDuration:1) {
                self.view.layoutIfNeeded()
            }
            
        } else {
            self.sectionHeightConstraint.priority = UILayoutPriority(rawValue: 250)
            NSLayoutConstraint.activate([self.bottomInternalConstraint])
            UIView.animate(withDuration:1) {
                self.view.layoutIfNeeded()
            }
        }
    }

}
