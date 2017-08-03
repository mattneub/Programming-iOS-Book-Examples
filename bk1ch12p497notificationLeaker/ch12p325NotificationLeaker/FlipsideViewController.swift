

import UIKit

protocol FlipsideViewControllerDelegate : class {
    func flipsideViewControllerDidFinish(_ controller:FlipsideViewController)
}

extension Notification.Name {
    static let woohoo = Notification.Name("woohoo")
}

class FlipsideViewController: UIViewController {
    
    weak var delegate : FlipsideViewControllerDelegate!
    
    var observer : Any!
    
    let which = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch which {
        case 0:
            self.observer = NotificationCenter.default.addObserver(
            forName: .woohoo, object:nil, queue:nil) {
                _ in
                print("The observer still exists!")
                _ = self.description // leak me, leak me
            }
            // do we still leak if we _don't_ retain the observer? yes
            // (and so does the observer of course)
            self.observer = nil
        case 1:
            self.observer = NotificationCenter.default.addObserver(
            forName: .woohoo, object:nil, queue:nil) {
                [unowned self] _ in // ha ha, fixed it
                print("The observer still exists!")
                _ = self.description
            }
            // do we still leak if we _don't_ retain the observer? no,
            // but the observer has leaked!
            // and now we are in a very dangerous situation...
            // because the observer has a danging pointer to self;
            // we will crash if the notification is posted
            // self.observer = nil
        case 2:
            self.observer = NotificationCenter.default.addObserver(
            forName: .woohoo, object:nil, queue:nil) {
                [weak self] _ in
                print("The observer still exists!")
                // try weak instead
                _ = self?.description
            }
            // now do we still leak if don't retain the observer?
            // no, but the observer has leaked
            // however, at least this is safe because the observer will not do anything
            self.observer = nil
        default:break
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let ob = self.observer {
            print("unregister")
            NotificationCenter.default.removeObserver(ob)
        }
    }
    
    @IBAction func done (_ sender: Any!) {
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
