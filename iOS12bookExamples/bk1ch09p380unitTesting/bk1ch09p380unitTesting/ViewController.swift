

import UIKit

class ViewController: UIViewController {

    func dogMyCats(_ s:String) -> String {
        // return "" // fail test; comment out to pass test
        return "dogs"
    }

    @IBAction func buttonPressed(_ sender: Any) {
        let alert = UIAlertController(
            title: "Howdy!", message: "You tapped me!", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }


}

