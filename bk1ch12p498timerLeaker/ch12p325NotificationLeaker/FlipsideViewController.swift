

import UIKit

protocol FlipsideViewControllerDelegate : class {
    func flipsideViewControllerDidFinish(controller:FlipsideViewController)
}

class FlipsideViewController: UIViewController {
    
    weak var delegate : FlipsideViewControllerDelegate!
    
    var timer : NSTimer!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("starting timer")
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "dummy:", userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
    }
    
    func dummy(t:NSTimer) {
        print("timer fired")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // return; // uncomment and we will leak
        print("invalidate")
        self.timer?.invalidate()
    }
    
    @IBAction func done (sender:AnyObject!) {
        print("done")
        self.delegate?.flipsideViewControllerDidFinish(self)
    }
    
    // if deinit is not called when you tap Done, we are leaking
    deinit {
        print("deinit")
    }
    
}

extension FlipsideViewController : UIBarPositioningDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
