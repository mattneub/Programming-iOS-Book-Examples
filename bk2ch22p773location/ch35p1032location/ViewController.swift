
import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locman = CLLocationManager()
    var startTime : NSDate!
    var trying = false
    
    @IBAction func doFindMe (sender:AnyObject!) {
        let ok = CLLocationManager.locationServicesEnabled()
        if !ok {
            println("Alas") // could put up an alert
            return
        }
        let stat = CLLocationManager.authorizationStatus()
        if stat == CLAuthorizationStatus.Restricted {
            println("Oh, well") // pointless, we can't be enabled
            return
        }
        // new iOS 8 feature: we can switch to our own preferences...
        // ...so if user has denied us, we can urge authorization on our behalf
        if stat == CLAuthorizationStatus.Denied {
            let alert = UIAlertController(title: "Authorization Needed", message: "Wouldn't you like to authorize this app's use of Location Services?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                _ in
                let url = NSURL(string: UIApplicationOpenSettingsURLString)
                UIApplication.sharedApplication().openURL(url)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            // if user does this, we will _NOT_ crash!
            return
        }
        locman.requestWhenInUseAuthorization() // if this causes the request dialog...
        // ... and if the user denies us, then startUpdatingLocation() will fail...
        // ... and we will fall into didFailWithError - so we'll shut everything down there
        if self.trying { return }
        self.trying = true
        locman.delegate = self
        locman.desiredAccuracy = kCLLocationAccuracyBest
        locman.activityType = .Fitness
        self.startTime = nil
        println("starting")
        locman.startUpdatingLocation()
    }
    
    func stopTrying () {
        locman.stopUpdatingLocation()
        self.startTime = nil
        self.trying = false
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("failed: \(error)")
        self.stopTrying()
    }
    
    let REQ_ACC : CLLocationAccuracy = 10
    let REQ_TIME : NSTimeInterval = 10
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let loc = locations.last as CLLocation
        let acc = loc.horizontalAccuracy
        let time = loc.timestamp
        let coord = loc.coordinate
        if self.startTime == nil {
            self.startTime = NSDate()
            return // ignore first attempt
        }
        println(acc)
        let elapsed = time.timeIntervalSinceDate(self.startTime)
        if elapsed > REQ_TIME {
            println("This is taking too long")
            self.stopTrying()
            return
        }
        if acc < 0 || acc > REQ_ACC {
            return // wait for the next one
        }
        // got it
        println("You are at \(coord.latitude) \(coord.longitude)")
        self.stopTrying()
    }

}
