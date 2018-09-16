

import UIKit
import CoreLocation

// to test, first reset simulator's content and settings

class MyDelegate : NSObject, CLLocationManagerDelegate {
    
}

class ViewController: UIViewController {
    
    var locman : CLLocationManager!
    var del : MyDelegate! = MyDelegate()

    @IBAction func doButton1(_ sender: Any) {
        self.locman = CLLocationManager()
        self.locman.delegate = self.del
    }
    
    let crash = true
    
    @IBAction func doButton2(_ sender: Any) {
        if crash {
            self.del = nil
        }
        if let loc = self.locman {
            loc.requestAlwaysAuthorization()
        }
    }

}

