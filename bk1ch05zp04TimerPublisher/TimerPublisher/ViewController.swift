

import UIKit
import Combine

class ViewController: UIViewController {

    // showing that a publisher vends an async sequence
    // and that a for loop is not the only thing you can do with an async sequence
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timerpub = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
        let values = timerpub.values
        Task {
            var iter = values.makeAsyncIterator()
            while let value = await iter.next() {
                print(value)
            }
        }
    }
    // other built-in async sequences - e.g. file handle bytes
    func test() {
        if let url = Bundle.main.url(forResource: "test", withExtension: "txt") {
            if let fh = try? FileHandle(forReadingFrom: url) {
                Task {
                    for try await byte in fh.bytes {
                        // do something with this byte
                        print(byte)
                    }
                }
            }
        }
    }
    // notifications
    func test2() {
        let notifs = NotificationCenter.default.notifications(
            named: UIApplication.didBecomeActiveNotification,
            object: nil)
        Task {
            for await notif in notifs {
                // if we get here, application just became active
                print(notif)
            }
        }
    }


}

