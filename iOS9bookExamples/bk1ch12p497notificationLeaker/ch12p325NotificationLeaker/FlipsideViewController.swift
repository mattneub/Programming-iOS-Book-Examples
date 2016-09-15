

import UIKit

protocol FlipsideViewControllerDelegate : class {
    func flipsideViewControllerDidFinish(controller:FlipsideViewController)
}

class FlipsideViewController: UIViewController {
    
    weak var delegate : FlipsideViewControllerDelegate!
    
    var observer : AnyObject!
    
    let which = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        switch which {
        case 0:
            self.observer = NSNotificationCenter.defaultCenter().addObserverForName(
                "woohoo", object:nil, queue:nil) {
                    _ in
                    self.description // leak me, leak me
            }
        case 1:
            self.observer = NSNotificationCenter.defaultCenter().addObserverForName(
                "woohoo", object:nil, queue:nil) {
                    [unowned self] _ in // ha ha, fixed it
                    self.description
            }
        default:break
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("unregister")
        NSNotificationCenter.defaultCenter().removeObserver(self.observer)
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
