

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


protocol FlipsideViewControllerDelegate : class {
    func flipsideViewControllerDidFinish(_ controller:FlipsideViewController)
}

extension Notification.Name {
    static let woohoo = Notification.Name("woohoo")
}

class FlipsideViewController: UIViewController {
    
    weak var delegate : FlipsideViewControllerDelegate!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // type 1
        NotificationCenter.default.addObserver(self, selector: #selector(woohooWasCalled), name: .woohoo, object: nil)
        // type 2
        NotificationCenter.default.addObserver(forName: .woohoo, object: nil, queue: nil) { _ in
            print("woohoo2")
            // print(self) // comment out to leak as well
        }
        print("testing the notification while we exist")
        print("wait one second please")
        delay(1) {
            NotificationCenter.default.post(name: .woohoo, object: nil)
        }
        
    }
    
    @objc func woohooWasCalled() {
        print("woohoo")
    }
    
    // proving that we do not crash when the NC posts to an object
    // ...that was never unregistered
    
    // however, we still do have to worry about the observer object from the second type
    // it leaks if not unregistered (_we_ don't leak as long as we don't retain self, but _it_ does)
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("do NOT unregister")
        print("in fact, send the notification 2 seconds from now!")
        delay(2) {
            print("sending")
            NotificationCenter.default.post(name: .woohoo, object: nil)
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
