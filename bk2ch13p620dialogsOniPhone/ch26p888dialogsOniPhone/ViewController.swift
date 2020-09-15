

import UIKit

class MyAlertController : UIAlertController {}

extension UIResponder {
    func next<T:UIResponder>(ofType: T.Type) -> T? {
        let r = self.next
        if let r = r as? T ?? r?.next(ofType: T.self) {
            return r
        } else {
            return nil
        }
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    var alertString = ""
    
    @IBAction func doAlertView(_ sender: Any) {
        let alert = UIAlertController(title: "Not So Fast!",
            message: """
            Do you really want to do this \
            tremendously destructive thing?
            """,
            preferredStyle: .alert)
        // no delegate needed merely to catch which button was tapped;
        // a UIAlertAction has a handler
        // here's a general handler (though none is needed if you want to ignore)
        func handler(_ act:UIAlertAction) {
            print("User tapped \(act.title as Any)")
        }
        // illustrating the three button styles
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: handler))
        alert.addAction(UIAlertAction(title: "Just Do It!", style: .destructive, handler: handler))
        alert.addAction(UIAlertAction(title: "Maybe", style: .default, handler: handler))
        // the last default one is bold in any case
        // but new in iOS 9, seems to boldify the designated button title instead
        // alert.preferredAction = alert.actions[2]

        self.present(alert, animated: true)
        // dismissal is automatic when a button is tapped
    }
    
    // =====
    
    @IBAction func doAlertView2(_ sender: Any) {
        let alert = UIAlertController(title: "Enter a number:", message: nil, preferredStyle: .alert)
        alert.addTextField { tf in
            tf.keyboardType = .numberPad // ??? not on iPad
            tf.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
            tf.delegate = self
        }
        func handler(_ act:UIAlertAction) {
            // it's a closure so we have a reference to the alert
            let tf = alert.textFields![0] 
            print("User entered \(tf.text as Any), tapped \(act.title as Any)")
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        alert.actions[1].isEnabled = false
        self.present(alert, animated: true)
    }
    
    @objc func textChanged(_ sender: Any) {
        let tf = sender as! UITextField
        // enable OK button only if there is text
        // hold my beer and watch this: how to get a reference to the alert
        let alert = tf.next(ofType: UIAlertController.self)
        alert?.actions[1].isEnabled = (tf.text != "")
    }
    
    // there is no Return key in the dialog, but we still need to stop a user with a hardware keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.text != ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        if Int(string) == nil { return false }
        return true
    }

    
    // =====
    
    @IBAction func doActionSheet(_ sender: Any) {
        let alert = UIAlertController(title: "Not So Fast!",
                                      message: """
            Do you really want to do this \
            tremendously destructive thing?
            """,
                                      preferredStyle: .actionSheet)
        func handler(_ act:UIAlertAction) {
            print("User tapped \(act.title as Any)")
        }
        // illustrating the three button styles
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: handler))
        alert.addAction(UIAlertAction(title: "Just Do It!", style: .destructive, handler: handler))
        alert.addAction(UIAlertAction(title: "Maybe", style: .default, handler: handler))
        self.present(alert, animated: true)
    }
}
