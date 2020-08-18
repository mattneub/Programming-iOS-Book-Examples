

import UIKit


class ViewController: UIViewController {
    
    private lazy var instanceOnce : Void = {
        print("once in an instance")
    }()

    @IBAction func doOnceInALifetime(_ sender: Any) {
        globalOnce
    }
    
    @IBAction func doOnceInAViewController(_ sender: Any) {
        _ = self.instanceOnce
    }

}

