

import UIKit

protocol FlipsideViewControllerDelegate : class {
    func flipsideViewControllerDidFinish(_ controller:FlipsideViewController)
}

class FlipsideViewController: UIViewController {
    
    weak var delegate : FlipsideViewControllerDelegate!
    
    var timer : Timer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("starting timer")
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            [unowned self] // comment out and we will leak
            t in
            self.fired(t)
        }
        self.timer.tolerance = 0.1
    }
    
    func fired(_ t:Timer) {
        print("timer fired")
    }
    
    @IBAction func done (_ sender: Any!) {
        print("done")
        self.delegate?.flipsideViewControllerDidFinish(self)
    }
    
    // if deinit is not called when you tap Done, we are leaking
    deinit {
        self.timer.invalidate()
        print("deinit")
    }
    
}

extension FlipsideViewController : UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
