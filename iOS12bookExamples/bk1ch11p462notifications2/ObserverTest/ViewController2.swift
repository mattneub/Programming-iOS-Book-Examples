

import UIKit

class ViewController2: UIViewController {
    
    static let notif = Notification.Name("notif")

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("registering observer")
        let _ = NotificationCenter.default.addObserver(forName: ViewController2.notif, object: nil, queue: nil) { _ in
            print("notification received")
        }
    }

}
