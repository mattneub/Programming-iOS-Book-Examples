

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonPressed(sender:AnyObject) {
        let alert = UIAlertController(
            title: NSLocalizedString("ATitle", comment:"Howdy!"),
            message: NSLocalizedString("AMessage", comment:"You tapped me!"),
            preferredStyle: .Alert)
        alert.addAction(
            UIAlertAction(title: NSLocalizedString("Accept", comment:"OK"),
                style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }


}

