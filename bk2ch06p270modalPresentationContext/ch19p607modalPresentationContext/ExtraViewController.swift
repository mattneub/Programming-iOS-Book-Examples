

import UIKit

class ExtraViewController : UIViewController {
    @IBAction func doButton (sender : AnyObject) {
        println("presented vc's presenting vc: \(self.presentingViewController)")
        self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
