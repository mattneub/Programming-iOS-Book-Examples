
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
    
    @discardableResult
    func determineStatus() -> Bool {
        guard CLLocationManager.locationServicesEnabled() else {
            self.locman.startUpdatingLocation() // might get "enable" dialog
            return false
        }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .notDetermined:
            self.locman.requestWhenInUseAuthorization()
            // locman.requestAlwaysAuthorization()
            return false
        case .restricted:
            return false
        case .denied:
            let message = "Wouldn't you like to authorize" +
            "this app to use Location Services?"
            let alert = UIAlertController(title: "Need Authorization", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            alert.addAction(UIAlertAction(title: "OK", style: .default) {
                _ in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.shared().open(url)
            })
            self.present(alert, animated:true)
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("did change auth: \(status.rawValue)")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.doThisWhenAuthorized?()
        default: break
        }
    }
    
    let which = 2 // 1 is old way, 2 is new way
    
    @IBAction func doFindMe (_ sender:AnyObject!) {
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
            self.locman.activityType = .fitness
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
        print("failed: \(error)")
        self.stopTrying()
    }
    
    let REQ_ACC : CLLocationAccuracy = 10
    let REQ_TIME : NSTimeInterval = 10
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
            let elapsed = time.timeIntervalSince(self.startTime)
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
