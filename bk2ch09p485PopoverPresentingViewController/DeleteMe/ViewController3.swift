
import UIKit

class ViewController3: UIViewController {
    
    let workaround = false
    
    override func viewWillAppear(animated: Bool) {
        // okay, this is really weird: you need _both_!
        // note that this works only on iOS 9! no effect on iOS 8 (and probably not before either)
        if workaround {
            self.modalInPopover = true
            self.presentingViewController?.modalInPopover = true
        }
    }

    @IBAction func doDone(sender: AnyObject) {
        // and then on dismissal must undo both!
        if workaround {
            self.modalInPopover = false
            self.presentingViewController?.modalInPopover = false
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
