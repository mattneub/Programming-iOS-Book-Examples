

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doSendURL(_ sender: Any) {
        let url = URL(string:"https://www.apeth.com/testing/1")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

