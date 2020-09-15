
import UIKit

class ViewController: UIViewController {

    var timer : Timer!
    
    // this will crash; don't do this
    // var timer2 : Timer? = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    
    var timer3 : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer3 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in print("fired")
        }
    }
    
    @objc func timerFired(_ : Timer) {
        print("fired2")
    }


}

