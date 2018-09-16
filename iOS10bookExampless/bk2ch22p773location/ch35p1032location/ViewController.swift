
import UIKit
import CoreLocation

class ManagerHolder {
    let locman = CLLocationManager()
    var doThisWhenAuthorized : (() -> ())?
    func checkForLocationAccess(always:Bool = false, andThen f: (()->())? = nil) {
        // no services? fail but try get alert
        guard CLLocationManager.locationServicesEnabled() else {
            print("no location services")
            self.locman.startUpdatingLocation()
            return
        }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            f?()
        case .notDetermined:
            self.doThisWhenAuthorized = f
            always ?
                self.locman.requestAlwaysAuthorization() :
                self.locman.requestWhenInUseAuthorization()
        case .restricted:
            // do nothing
            break
        case .denied:
            print("denied")
            // do nothing, or beg the user to authorize us in Settings
            break
        }
    }
}



class ViewController: UIViewController, CLLocationManagerDelegate {
    let managerHolder = ManagerHolder()
    var locman : CLLocationManager {
        return self.managerHolder.locman
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.locman.delegate = self
    }
    
    var startTime : Date!
    var trying = false
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("did change auth: \(status.rawValue)")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.managerHolder.doThisWhenAuthorized?()
            self.managerHolder.doThisWhenAuthorized = nil
        default: break
        }
    }
    
    let which = 1 // 1 or 2
    
    @IBAction func doFindMe (_ sender: Any!) {
        self.managerHolder.checkForLocationAccess {
            switch self.which {
            case 1:
                if self.trying { return }
                self.trying = true
                self.locman.desiredAccuracy = kCLLocationAccuracyBest
                self.locman.activityType = .fitness
                self.startTime = nil
                print("starting")
                self.locman.startUpdatingLocation()
            case 2:
                print("requesting")
                self.locman.desiredAccuracy = kCLLocationAccuracyBest
                self.locman.requestLocation()
            default: break
            }
        }
    }
    
    
    
    func stopTrying () {
        self.locman.stopUpdatingLocation()
        self.startTime = nil
        self.trying = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed: \(error)")
        self.stopTrying()
    }
    
    let REQ_ACC : CLLocationAccuracy = 10
    let REQ_TIME : TimeInterval = 10
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        switch which {
        case 1:
            print("did update location ")
            let loc = locations.last!
            let acc = loc.horizontalAccuracy
            let time = loc.timestamp
            let coord = loc.coordinate
            if self.startTime == nil {
                self.startTime = Date()
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
            // bug: can be called twice in quick succession
        default: break
        }
    }

}
