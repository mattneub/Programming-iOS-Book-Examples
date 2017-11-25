
import UIKit

class ViewController: UIViewController {
    @IBOutlet var textFields : [UITextField]!
    var fr: UIResponder!
    var accessoryView : UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // configure accessory view
        let arr = UINib(nibName:"AccessoryView", bundle:nil).instantiate(withOwner:nil)
        self.accessoryView = arr[0] as! UIView
        let b = self.accessoryView.subviews[0] as! UIButton
        b.addTarget(self, action:#selector(doNextButton), for:.touchUpInside)
        // new iOS 10 feature, just testing
        // didn't behave well, not documenting
//        for tf in self.textFields {
//            tf.textContentType = .emailAddress
//        }
    }
    


    func textFieldDidBeginEditing(_ tf: UITextField) {
        self.fr = tf // keep track of first responder
        tf.inputAccessoryView = self.accessoryView
        tf.keyboardAppearance = .dark
        
        
    }

    func textFieldShouldReturn(_ tf: UITextField) -> Bool {
        self.fr = nil
        tf.resignFirstResponder()
        return true
    }
    
    func doNextButton(_ sender: Any) {
        var ix = self.textFields.index(of:self.fr as! UITextField)!
        ix = (ix + 1) % self.textFields.count
        let v = self.textFields[ix]
        v.becomeFirstResponder()
    }
    
    
}
