
import UIKit

class CancelableTimer: NSObject {
    private var q = DispatchQueue(label: "timer")
    private var timer : DispatchSourceTimer!
    private var firsttime = true
    private var once : Bool
    private var handler : () -> ()
    init(once:Bool, handler:@escaping ()->()) {
        self.once = once
        self.handler = handler
        super.init()
    }
    func start(withInterval interval:Double) {
        self.firsttime = true
        self.cancel()
        self.timer = DispatchSource.makeTimerSource(queue: self.q)
        self.timer.schedule(wallDeadline: .now(), repeating: interval) // renamed
        // self.timer.scheduleRepeating(deadline: .now(), interval: 1, leeway: .milliseconds(1))
        self.timer.setEventHandler {
            if self.firsttime {
                self.firsttime = false
                return
            }
            self.handler()
            if self.once {
                self.cancel()
            }
        }
        self.timer.resume()
    }
    func cancel() {
        if self.timer != nil {
            timer.cancel()
        }
    }
    deinit {
        print("deinit cancelable timer")
    }
}
