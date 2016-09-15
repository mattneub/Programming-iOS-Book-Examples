
import UIKit

class ViewController3: UIViewController {
    
    let workaround = true
    
    var oldModal = false
    
    override func viewWillAppear(animated: Bool) {
        // okay, this is really weird: you need _both_!
        // note that this works only on iOS 9! no effect on iOS 8
        if workaround {
            if let pres = self.presentingViewController {
                self.modalInPopover = true
                self.oldModal = pres.modalInPopover
                pres.modalInPopover = true
            }
        }
    }

    @IBAction func doDone(sender: AnyObject) {
        // and then on dismissal must undo both!
        if workaround {
            if let pres = self.presentingViewController {
                self.modalInPopover = false
                pres.modalInPopover = self.oldModal
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
