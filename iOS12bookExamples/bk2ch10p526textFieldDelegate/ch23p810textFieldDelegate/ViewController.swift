

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tf : UITextField!
    
    // how to make keyboard initially appear in Russian if enabled
    override var textInputMode: UITextInputMode? {
        print("get")
        // return super.textInputMode
        
        for tim in UITextInputMode.activeInputModes {
            if tim.primaryLanguage == "ru-RU" {
                return tim
            }
        }
        print("super", super.textInputMode?.primaryLanguage as Any)
        return super.textInputMode
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tf.allowsEditingTextAttributes = true
        
        let mi = UIMenuItem(title:"Expand", action:#selector(MyTextField.expand))
        let mc = UIMenuController.shared
        mc.menuItems = [mi]

    }
    
    func beRed(_ textField : UITextField) {
        // user's text is always red, underlined
        if var md = textField.typingAttributes {
            let d : [NSAttributedString.Key:Any] = [
                .foregroundColor:
                    UIColor.red,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            md.merge(d) {_,new in new}
            textField.typingAttributes = md
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.textInputMode?.primaryLanguage as Any) // wrong

        self.beRed(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // print("here '\(string)'")
        
        if string == "\n" {
            return true // otherwise, our automatic keyboard dismissal trick won't work
        }
        
        // backspace
        if string.isEmpty {
            return true
        }
        // user can enter lowercase only
        let lc = string.lowercased()
        textField.insertText(lc) // from UIKeyInput protocol

        self.beRed(textField)
        
        print(textField.textInputMode?.primaryLanguage as Any) // right

        
        return false

    }

    // can prevent automatic dismissal
    func textFieldShouldReturnNOT(_ textField: UITextField) -> Bool {
        return false
    }

}
