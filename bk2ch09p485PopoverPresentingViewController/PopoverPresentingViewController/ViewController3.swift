
import UIKit

class ViewController3: UIViewController {
    
    let workaround = false
    
    var oldModal = false
    
    override func viewWillAppear(_ animated: Bool) {
        // okay, this is really weird: you need _both_!
        // note that this works only on iOS 9! no effect on iOS 8
        if workaround {
            if let pres = self.presentingViewController {
                self.isModalInPopover = true
                self.oldModal = pres.isModalInPopover
                pres.isModalInPopover = true
            }
        }
    }

    @IBAction func doDone(_ sender: Any) {
        // and then on dismissal must undo both!
        if workaround {
            if let pres = self.presentingViewController {
                self.isModalInPopover = false
                pres.isModalInPopover = self.oldModal
            }
        }
        self.dismiss(animated:true)
    }

    
}
