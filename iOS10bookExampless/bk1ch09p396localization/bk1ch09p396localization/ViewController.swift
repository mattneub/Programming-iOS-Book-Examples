

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonPressed(_ sender: Any) {
        let alert = UIAlertController(
            title: NSLocalizedString("ATitle", comment:"Howdy!"),
            message: NSLocalizedString("AMessage", comment:"You tapped me!"),
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: NSLocalizedString("Accept", comment:"OK"),
                style: .cancel))
        self.present(alert, animated: true)
    }


}

