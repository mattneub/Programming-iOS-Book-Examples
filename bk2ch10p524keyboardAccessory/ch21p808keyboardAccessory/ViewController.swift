
import UIKit

class ViewController: UIViewController {
    @IBOutlet var textFields : [UITextField]!
    var fr: UIResponder!
    var accessoryView : UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // configure accessory view
        let arr = UINib(nibName:"AccessoryView", bundle:nil).instantiateWithOwner(nil, options:nil)
        self.accessoryView = arr[0] as! UIView
        let b = self.accessoryView.subviews[0] as! UIButton
        b.addTarget(self, action:"doNextButton:", forControlEvents:.TouchUpInside)
    }

    func textFieldDidBeginEditing(tf: UITextField) {
        self.fr = tf // keep track of first responder
        tf.inputAccessoryView = self.accessoryView
        tf.keyboardAppearance = .Dark
    }
    
    func textFieldShouldReturn(tf: UITextField) -> Bool {
        tf.resignFirstResponder()
        self.fr = nil
        return true
    }
    
    func doNextButton(sender:AnyObject) {
        var ix = (self.textFields as NSArray).indexOfObject(self.fr)
        ix = ++ix % self.textFields.count
        let v = self.textFields[ix]
        v.becomeFirstResponder()
    }
    
    
}
