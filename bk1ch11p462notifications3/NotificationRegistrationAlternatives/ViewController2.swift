

import UIKit


class ViewController2 : UIViewController {
    static let notif = Notification.Name("notif")
    
    @IBAction func doPost (_ sender:Any) {
        NotificationCenter.default.post(name: Self.notif, object: nil)
    }

}
