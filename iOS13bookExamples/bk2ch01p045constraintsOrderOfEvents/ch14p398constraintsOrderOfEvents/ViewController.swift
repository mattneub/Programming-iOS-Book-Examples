

import UIKit

class ViewController: UIViewController {

    @IBAction func doContractSafeArea(_ sender: Any) {
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 50, left: 20, bottom: 20, right: 20)
    }
    @IBAction func doContractMargins(_ sender: Any) {
        self.view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 50, leading: 50, bottom: 50, trailing: 50)
    }
    
}
