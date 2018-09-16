

import UIKit

protocol FlipsideViewControllerDelegate : class {
    func flipsideViewControllerDidFinish(_ controller:FlipsideViewController)
}

class FlipsideViewController: UIViewController {
    
    weak var delegate : FlipsideViewControllerDelegate!
    
    var timer : CancelableTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("creating timer")
        self.timer = CancelableTimer(once: false) {
            [unowned self] in // comment out this line to leak
            self.dummy()
        }
        print("starting timer")
        self.timer.start(withInterval:1)
    }
    
    func dummy() {
        print("timer fired")
    }
    
    @IBAction func done (_ sender: Any!) {
        print("done")
        self.delegate?.flipsideViewControllerDidFinish(self)
    }
    
    // if deinit is not called when you tap Done, we are leaking
    deinit {
        print("deinit")
        self.timer?.cancel()
    }
    
}

extension FlipsideViewController : UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
