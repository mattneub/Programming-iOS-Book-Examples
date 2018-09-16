
import UIKit

class ViewController: UIViewController {

    var timer : Timer!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in print("fired")
        }
    }


}

