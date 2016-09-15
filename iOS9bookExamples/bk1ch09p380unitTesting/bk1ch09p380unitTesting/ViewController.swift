

import UIKit

class ViewController: UIViewController {

    func dogMyCats(s:String) -> String {
        return "dogs"
    }

    @IBAction func buttonPressed(sender:AnyObject) {
        let alert = UIAlertController(
            title: "Howdy!", message: "You tapped me!", preferredStyle: .Alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }


}

