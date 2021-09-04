

import UIKit
import Combine

protocol FlipsideViewControllerDelegate : AnyObject {
    func flipsideViewControllerDidFinish(_ controller:FlipsideViewController)
}

extension Notification.Name {
    static let woohoo = Notification.Name("woohoo")
}

// bad things happen unless you do _both_ the starred things

class FlipsideViewController: UIViewController {
    
    weak var delegate : FlipsideViewControllerDelegate!
    
    var observers = Set<NSObject>()
    var storage = Set<AnyCancellable>()
    // async task
    var task = Task {
        let stream = NotificationCenter.default.notifications(named: .woohoo)
        for await _ in stream {
            print("Task observing!", self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // register observer
        let ob = NotificationCenter.default.addObserver(
        forName: .woohoo, object:nil, queue:nil) {
            [unowned self] // *
            _ in
            print("Observer token observing!")
            print(self.description) // leak me, leak me
        }
        self.observers.insert(ob as! NSObject)
        
        // combine pipeline
        NotificationCenter.default.publisher(for: .woohoo)
            .sink {
                [unowned self] // *
                _ in
                print("Combine pipeline observing!", self) }
            .store(in: &self.storage)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func done (_ sender: Any) {
        print("done")
        self.delegate?.flipsideViewControllerDidFinish(self)
    }
    
    // if deinit is not called when you tap Done, we are leaking
    deinit {
        print("deinit")
        // observer token:
        for ob in self.observers {
            NotificationCenter.default.removeObserver(ob) // *
        }
        // Combine pipeline:
        // nothing needed!
        // task:
        self.task.cancel() // *
    }
    
}

extension FlipsideViewController : UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
