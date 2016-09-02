

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tf : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tf.allowsEditingTextAttributes = true
        
        let mi = UIMenuItem(title:"Expand", action:#selector(MyTextField.expand))
        let mc = UIMenuController.shared
        mc.menuItems = [mi]

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("here '\(string)'")
        
        if string == "\n" {
            return true // otherwise, our automatic keyboard dismissal trick won't work
        }
        
        // force user to type in red, underlined, lowercase only
        
        let lc = string.lowercased()
        textField.text = (textField.text! as NSString).replacingCharacters(in:range,
                with:lc)
        
        // not very satisfactory but it does show the result
        
        let md = (textField.typingAttributes! as NSDictionary).mutableCopy() as! NSMutableDictionary
        let d : [String:Any] = [
            NSForegroundColorAttributeName:
                UIColor.red,
            NSUnderlineStyleAttributeName:
                NSUnderlineStyle.styleSingle.rawValue
        ]
        md.addEntries(from:d)
        textField.typingAttributes = md.copy() as? [String:AnyObject]
        
        return false

    }


}
