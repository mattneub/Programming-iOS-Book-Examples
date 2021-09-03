

import UIKit
import Combine

class ViewController2: UIViewController {
    
    static let notif = Notification.Name("notif")

    var which = 1
    
    // let's also add some alternative ways of getting notifications, namely by subscribing
    var storage = Set<AnyCancellable>()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch which {
        case 0:
            print("registering observer")
            let _ = NotificationCenter.default.addObserver(forName: ViewController2.notif, object: nil, queue: nil) { _ in
                print("notification received")
            }
        case 1:
            print("subscribing with Combine")
            NotificationCenter.default.publisher(for: ViewController2.notif)
                .sink { _ in print("notification received") }
                .store(in: &self.storage)
        case 2:
            print("subscribing with async stream")
            let stream = NotificationCenter.default.notifications(named: ViewController2.notif)
            Task {
                for await _ in stream {
                    print("notification received")
                }
            }
        default: break
        }
        
        
    }

}
