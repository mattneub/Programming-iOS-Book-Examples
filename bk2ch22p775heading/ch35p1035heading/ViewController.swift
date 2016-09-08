

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var lab : UILabel!
    lazy var locman : CLLocationManager = {
        let locman = CLLocationManager()
        locman.delegate = self
        return locman
        }()
    var updating = false
    
    @IBAction func doStart (_ sender: Any!) {
        guard CLLocationManager.headingAvailable() else {return} // lacking hardware
        if self.updating {return}
        print("starting")
        self.locman.headingFilter = 5
        self.locman.headingOrientation = .portrait
        self.updating = true
        // NO AUTH NEEDED!
        // the heading part works just fine even if Location Services is turned off
        // and if it is turned on, we will get true-north
        // seems like a major bug to me
        self.locman.startUpdatingHeading()
    }
    
    @IBAction func doStop (_ sender: Any!) {
        self.locman.stopUpdatingHeading()
        self.lab.text = ""
        self.updating = false
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
        self.doStop(nil)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        var h = newHeading.magneticHeading
        let h2 = newHeading.trueHeading // will be -1 if we have no location info
        print("\(h) \(h2) ")
        if h2 >= 0 {
            h = h2
        }
        let cards = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        var dir = "N"
        for (ix, card) in cards.enumerated() {
            if h < 45.0/2.0 + 45.0*Double(ix) {
                dir = card
                break
            }
        }
        if self.lab.text != dir {
            self.lab.text = dir
        }
        print(dir)
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true // if you want the calibration dialog to be able to appear
        // I did in fact see it appear, so this works in iOS 8.3 at least
    }


}
