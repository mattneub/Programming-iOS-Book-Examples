
import UIKit
import Combine

class ViewController: UIViewController {

    var timer : Timer!
    
    // this will crash; don't do this
    // var timer2 : Timer? = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    
    var timer3 : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer3 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in print("fired")
        }
    }
    
    @objc func timerFired(_ : Timer) {
        print("fired2")
    }

    var pipeline : AnyCancellable?
    func test() {
        // just showing syntax
        self.pipeline = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { print("timer fired at", $0) }
        // ...
        self.pipeline = nil
    }
    var task : Task<(), Never>?
    func test2() {
        // ditto
        let timerpub = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
        self.task = Task {
            for await value in timerpub.values {
                print("timer fired at", value)
            }
        }
        // ...
        self.task?.cancel()
        self.task = nil
    }


}

