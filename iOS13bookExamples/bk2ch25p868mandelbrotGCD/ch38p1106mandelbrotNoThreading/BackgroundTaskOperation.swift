
import UIKit

class BackgroundTaskOperation: Operation {
    var whatToDo : (() -> ())?
    var cleanup : (() -> ())?
    override func main() {
        guard !self.isCancelled else { return }
        assert(!Thread.isMainThread)
        var bti : UIBackgroundTaskIdentifier = .invalid
        bti = UIApplication.shared.beginBackgroundTask {
            print("out of time, calling endBackgroundTask, cancelling")
            UIApplication.shared.endBackgroundTask(bti)
            self.cleanup?()
            self.cancel()
        }
        guard bti != .invalid else { return }
        whatToDo?()
        print("completed")
        guard !self.isCancelled else { return }
        print("calling endBackgroundTask")
        UIApplication.shared.endBackgroundTask(bti)
    }
    func doOnMainQueueAndBlockUntilFinished(_ f:@escaping ()->()) {
        OperationQueue.main.addOperations([BlockOperation(block: f)], waitUntilFinished: true)
    }
}
