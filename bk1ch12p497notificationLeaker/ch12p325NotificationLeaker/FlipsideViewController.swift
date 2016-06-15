

import UIKit

protocol FlipsideViewControllerDelegate : class {
    func flipsideViewControllerDidFinish(_ controller:FlipsideViewController)
}

class FlipsideViewController: UIViewController {
    
    weak var delegate : FlipsideViewControllerDelegate!
    
    var observer : AnyObject!
    
    let which = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch which {
        case 0:
            self.observer = NotificationCenter.default().addObserver(
                forName: "woohoo" as Notification.Name, object:nil, queue:nil) {
                    _ in
                    _ = self.description // leak me, leak me
            }
        case 1:
            self.observer = NotificationCenter.default().addObserver(
                forName: "woohoo" as Notification.Name, object:nil, queue:nil) {
                    [unowned self] _ in // ha ha, fixed it
                    _ = self.description
            }
        default:break
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("unregister")
        NotificationCenter.default().removeObserver(self.observer)
    }
    
    @IBAction func done (_ sender:AnyObject!) {
        print("done")
        self.delegate?.flipsideViewControllerDidFinish(self)
    }
    
    // if deinit is not called when you tap Done, we are leaking
    deinit {
        print("deinit")
    }
    
}

extension FlipsideViewController : UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
