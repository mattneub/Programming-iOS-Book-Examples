
import UIKit

import StoreKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func doOrdinaryLink(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://www.apeth.com")!, options: [:], completionHandler: nil)
    }
    @IBAction func doUniversalLink(_ sender: Any) {
        // this doesn't work
        UIApplication.shared.open(URL(string:"https://www.apeth.com/testing/1")!, options: [:], completionHandler: nil)
    }


}

