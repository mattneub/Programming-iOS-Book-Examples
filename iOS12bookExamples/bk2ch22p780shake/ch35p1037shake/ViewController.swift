

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    // shake device (or simulator), watch console for response
    // note that this does not disable Undo by shaking in text field
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if self.isFirstResponder {
            print("hey, you shook me!")
            let alert = UIAlertController(title: "Hey", message: "You shook me!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        } else {
            super.motionEnded(motion, with: event)
        }
    }
    
    func textFieldDidEndEditing (_ textField:UITextField) {
        print("end editing")
        self.becomeFirstResponder()
    }
    
    

}
