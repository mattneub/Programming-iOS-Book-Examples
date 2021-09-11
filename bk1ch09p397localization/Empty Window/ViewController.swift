

import UIKit

class ViewController: UIViewController {

    
    @IBAction func buttonPressed(_ sender: Any) {
        let greeting = String(
            localized: "Howdy!",
            comment: "Alert title: Say hello")
        let message = String(
            localized: "You tapped me!",
            comment: "Alert message: Report a tap")
        let ok = String(
            localized: "OK",
            comment: "Alert button: accept and dismiss")
        let alert = UIAlertController(
            title: greeting,
            message: message,
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: ok,
                          style: .cancel))
        self.present(alert, animated: true)
    }



}

