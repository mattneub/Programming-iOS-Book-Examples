

import UIKit

class ViewController: UIViewController {

    // in the absence of a `key:` parameter,
    // I think the "right" way is to make the _key_ the text throughout the app
    // then explicitly localize for English, and then for other languages
    // in that way, the key can remain constant and we can change the English at will
    // and different keys can have the same English rendering
    
    @IBAction func buttonPressed(_ sender: Any) {
        let greeting = String(
            localized: "InformalHello",
            comment: "Alert title: Say hello informally")
        let message = String(
            localized: "ReportTap",
            comment: "Alert message: Report a tap")
        let ok = String(
            localized: "OKButton",
            comment: "Alert button: accept and dismiss")
        let alert = UIAlertController(
            title: greeting,
            message: message,
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: ok, style: .cancel))
        self.present(alert, animated: true)
    }



}

