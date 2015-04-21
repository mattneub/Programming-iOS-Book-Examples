
import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locman = CLLocationManager()
    var startTime : NSDate!
    var trying = false
    
    func determineStatus() -> Bool {
        let ok = CLLocationManager.locationServicesEnabled()
        if !ok {
            return true // ! this is so that we try to use it anyway...
            // system will put up a dialog suggesting the user turn on Location Services
        }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            return true
        case .NotDetermined:
            self.locman.requestWhenInUseAuthorization()
            // locman.requestAlwaysAuthorization()
            return true // NB, this is different from strategy in previous chapters
        case .Restricted:
            return false
        case .Denied:
            // new iOS 8 feature: sane way of getting the user directly to the relevant prefs
            // I think the crash-in-background issue is now gone
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use Location Services?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                _ in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.sharedApplication().openURL(url)
            }))
            self.presentViewController(alert, animated:true, completion:nil)
            return false
        }
    }
    
    @IBAction func doFindMe (sender:AnyObject!) {
        if !self.determineStatus() {
            println("not authorized")
            return
        }
        // if Location Services is off and we get here, system will suggest turning it on
        // if it's on and undetermined, we get the request dialog...
        // ... and if the user denies us, then startUpdatingLocation() will fail...
        // ... and we will fall into didFailWithError - so we'll shut everything down there
        if self.trying { return }
        self.trying = true
        self.locman.delegate = self
        self.locman.desiredAccuracy = kCLLocationAccuracyBest
        self.locman.activityType = .Fitness
        self.startTime = nil
        println("starting")
        self.locman.startUpdatingLocation()
    }
    
    func stopTrying () {
        self.locman.stopUpdatingLocation()
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
        print("did update location ")
        let loc = locations.last as! CLLocation
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
