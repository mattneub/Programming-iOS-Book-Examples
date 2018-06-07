
import UIKit
import CoreLocation

class ManagerHolder {
    let locman = CLLocationManager()
    var delegate : CLLocationManagerDelegate? {
        get {
            return self.locman.delegate
        }
        set {
            // set delegate _once_
            if self.locman.delegate == nil && newValue != nil {
                self.locman.delegate = newValue
                print("setting delegate!")
            }
        }
    }
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
        case .authorizedWhenInUse:
            if always { // try to step up
                self.doThisWhenAuthorized = f
                self.locman.requestAlwaysAuthorization()
            } else {
                f?()
            }
        case .authorizedAlways:
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
        self.managerHolder.delegate = self
    }
    @IBOutlet weak var tv: UITextView!
    
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
    
    let deferInterval : TimeInterval = 15*60
    
    @IBAction func doFindMe (_ sender: Any!) {
        self.managerHolder.checkForLocationAccess {
            if self.trying { return }
            self.trying = true
            self.locman.desiredAccuracy = kCLLocationAccuracyBest
            self.locman.activityType = .other
            self.locman.distanceFilter = kCLDistanceFilterNone
            self.startTime = nil
            self.locman.allowsBackgroundLocationUpdates = true
            self.print("starting")
            self.locman.startUpdatingLocation()
            self.s = ""
            self.tv.text = ""
            var ob : Any = ""
            ob = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: OperationQueue.main) {
                _ in
                NotificationCenter.default.removeObserver(ob)
                if CLLocationManager.deferredLocationUpdatesAvailable() {
                    self.print("going into background: deferring")
                    self.locman.allowDeferredLocationUpdates(untilTraveled: CLLocationDistanceMax, timeout: self.deferInterval)
                } else {
                    self.print("going into background but couldn't defer")
//                    self.print("but trying anyway")
//                    self.locman.allowDeferredLocationUpdates(untilTraveled: CLLocationDistanceMax, timeout: self.deferInterval)

                }

            }
            
        }
    }
    
    @IBAction func stopTrying () {
        self.locman.stopUpdatingLocation()
        self.startTime = nil
        self.trying = false
        self.tv.text = self.s
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        if let error = error {
            print(error)
        }
        let state = UIApplication.shared.applicationState
        if state == .background {
            if CLLocationManager.deferredLocationUpdatesAvailable() {
                print("deferring")
                self.locman.allowDeferredLocationUpdates(untilTraveled: CLLocationDistanceMax, timeout: self.deferInterval)
            } else {
                print("not able to defer")
                // if we try anyway, we just get error code 11
//                self.print("but trying anyway")
//                self.locman.allowDeferredLocationUpdates(untilTraveled: CLLocationDistanceMax, timeout: self.deferInterval)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("did update location ")
        let loc = locations.last!
        let acc = loc.horizontalAccuracy
        let coord = loc.coordinate
        print("\(Date()): Accuracy \(acc): You are at \(coord.latitude) \(coord.longitude)")
        let state = UIApplication.shared.applicationState
        if state == .background {
            let ok = CLLocationManager.deferredLocationUpdatesAvailable()
            print("deferred possible? \(ok)")
        }
    }
    
    var s = ""
    
    func print(_ s: Any) {
        self.s = self.s + "\n" + String(describing:s)
    }


}
