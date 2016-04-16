

import UIKit

class ViewController: UIViewController {
    // shake device (or simulator), watch console for response
    // note that this does not disable Undo by shaking in text field
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if self.isFirstResponder() {
            print("hey, you shook me!")
        } else {
            super.motionEnded(motion, with: event)
        }
    }
    
    func textFieldDidEndEditing (textField:UITextField) {
        print("end editing")
        self.becomeFirstResponder()
    }
    
    

}
