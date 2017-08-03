

import UIKit

protocol FlipsideViewControllerDelegate : class {
    func flipsideViewControllerDidFinish(_ controller:FlipsideViewController)
}

extension Notification.Name {
    static let woohoo = Notification.Name("woohoo")
}

class FlipsideViewController: UIViewController {
    
    weak var delegate : FlipsideViewControllerDelegate!
    
    var observers = Set<NSObject>()
    
    // uncomment ONE of the starred lines to solve the problem // *
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ob = NotificationCenter.default.addObserver(
        forName: .woohoo, object:nil, queue:nil) {
            // [unowned self] // *
            _ in
            print("The observer still exists!")
            print(self.description) // leak me, leak me
        }
        self.observers.insert(ob as! NSObject)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for ob in self.observers {
            NotificationCenter.default.removeObserver(ob)
        }
        // self.observers.removeAll() // *
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
