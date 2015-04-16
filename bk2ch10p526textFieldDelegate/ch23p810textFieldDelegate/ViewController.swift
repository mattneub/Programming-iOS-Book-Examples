

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tf : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tf.allowsEditingTextAttributes = true
        
        let mi = UIMenuItem(title:"Expand", action:"expand:")
        let mc = UIMenuController.sharedMenuController()
        mc.menuItems = [mi]

    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        println("here '\(string)'")
        
        if string == "\n" {
            return true // otherwise, our automatic keyboard dismissal trick won't work
        }
        
        // force user to type in red, underlined, lowercase only
        
        let lc = string.lowercaseString
        textField.text = (textField.text as NSString).stringByReplacingCharactersInRange(range,
                withString:lc)
        
        // not very satisfactory but it does show the result
        
        var md = (textField.typingAttributes! as NSDictionary).mutableCopy() as! NSMutableDictionary
        md.addEntriesFromDictionary([
            NSForegroundColorAttributeName: UIColor.redColor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
        ])
        textField.typingAttributes = md as [NSObject:AnyObject]
        
        return false

    }


}
