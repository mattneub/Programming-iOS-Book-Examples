

import UIKit

class ViewController: UIViewController {

    
    @IBAction func buttonPressed(_ sender: Any) {
        let alert = UIAlertController(
            title: NSLocalizedString(
                "Greeting", value:"Howdy!", comment:"Say hello"),
            message: NSLocalizedString(
                "Tapped", value:"You tapped me!", comment:"User tapped button"),
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: NSLocalizedString(
                "Accept", value:"OK", comment:"Dismiss"),
                          style: .cancel))
        self.present(alert, animated: true)
    }



}

