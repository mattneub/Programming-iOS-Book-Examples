
import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    lazy var locman : CLLocationManager = {
        let locman = CLLocationManager()
        locman.delegate = self
        return locman
    }()
    var startTime : NSDate!
    var trying = false
    var doThisWhenAuthorized : (() -> ())?
    
    func determineStatus() -> Bool {
        guard CLLocationManager.locationServicesEnabled() else {
            self.locman.startUpdatingLocation() // might get "enable" dialog
            return false
        }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            return true
        case .NotDetermined:
            self.locman.requestWhenInUseAuthorization()
            // locman.requestAlwaysAuthorization()
            return false
        case .Restricted:
            return false
        case .Denied:
            let message = "Wouldn't you like to authorize" +
            "this app to use Location Services?"
            let alert = UIAlertController(title: "Need Authorization", message: message, preferredStyle: .Alert)
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
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("did change auth: \(status.rawValue)")
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            self.doThisWhenAuthorized?()
        default: break
        }
    }
    
    let which = 2 // 1 is old way, 2 is new way
    
    @IBAction func doFindMe (sender:AnyObject!) {
        self.doThisWhenAuthorized = {
            [unowned self] in
            print("resuming")
            self.doFindMe(sender)
        }
        guard self.determineStatus() else {
            print("not authorized")
            return
        }
        self.doThisWhenAuthorized = nil
        
        switch which {
        case 1:
            if self.trying { return }
            self.trying = true
            self.locman.desiredAccuracy = kCLLocationAccuracyBest
            self.locman.activityType = .Fitness
            self.startTime = nil
            print("starting")
            self.locman.startUpdatingLocation()
        case 2:
            self.locman.desiredAccuracy = kCLLocationAccuracyBest
            self.locman.requestLocation()
        default: break
        }
    }
    
    func stopTrying () {
        self.locman.stopUpdatingLocation()
        self.startTime = nil
        self.trying = false
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("failed: \(error)")
        self.stopTrying()
    }
    
    let REQ_ACC : CLLocationAccuracy = 10
    let REQ_TIME : NSTimeInterval = 10
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        switch which {
        case 1:
            print("did update location ")
            let loc = locations.last!
            let acc = loc.horizontalAccuracy
            let time = loc.timestamp
            let coord = loc.coordinate
            if self.startTime == nil {
                self.startTime = NSDate()
                return // ignore first attempt
            }
            print(acc)
            let elapsed = time.timeIntervalSinceDate(self.startTime)
            if elapsed > REQ_TIME {
                print("This is taking too long")
                self.stopTrying()
                return
            }
            if acc < 0 || acc > REQ_ACC {
                return // wait for the next one
            }
            // got it
            print("You are at \(coord.latitude) \(coord.longitude)")
            self.stopTrying()
        case 2:
            let loc = locations.last!
            let coord = loc.coordinate
            print("The quick way: You are at \(coord.latitude) \(coord.longitude)")
        default: break
        }
    }

}
