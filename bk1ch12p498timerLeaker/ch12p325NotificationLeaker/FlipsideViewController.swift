

import UIKit

protocol FlipsideViewControllerDelegate : class {
    func flipsideViewControllerDidFinish(controller:FlipsideViewController)
}

class FlipsideViewController: UIViewController {
    
    weak var delegate : FlipsideViewControllerDelegate! = nil
    
    var timer : NSTimer!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("starting timer")
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "dummy:", userInfo: nil, repeats: true)
        self.timer.tolerance = 0.1
    }
    
    func dummy(t:NSTimer) {
        println("timer fired")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("invalidate")
        self.timer?.invalidate()
    }
    
    @IBAction func done (sender:AnyObject!) {
        println("done")
        self.delegate?.flipsideViewControllerDidFinish(self)
    }
    
    // if deinit is not called when you tap Done, we are leaking
    deinit {
        println("deinit")
    }
    
}

extension FlipsideViewController : UIBarPositioningDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
