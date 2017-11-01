
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
    var output = "" {
        willSet {
            // print(newValue)
        }
        didSet {
            self.tv.text = output
            self.tv.scrollRangeToVisible(NSMakeRange((self.tv.text as NSString).length-1,0))
        }
    }
    
    @IBOutlet weak var tv: UITextView!
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
        print("did change auth: \(status.rawValue)", to:&output)
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.managerHolder.doThisWhenAuthorized?()
            self.managerHolder.doThisWhenAuthorized = nil
        default: break
        }
    }
    
    var which = 0
    
    @IBAction func testWhenInUseRequest (_ sender: Any) {
        self.managerHolder.checkForLocationAccess()
    }
    
    @IBAction func testAlwaysRequest (_ sender: Any) {
        self.managerHolder.checkForLocationAccess(always:true)
    }

    @IBAction func doClear(_ sender: Any) {
        self.tv.text = ""
        self.output = ""
    }
    
    @IBAction func doFindMe (_ sender: Any) {
        self.managerHolder.checkForLocationAccess() {
            self.which = 1
            self.reallyFindMe()
        }
    }
    @IBAction func whereAmI(_ sender: Any) {
        self.managerHolder.checkForLocationAccess() {
            self.which = 2
            self.reallyFindMe()
        }

    }
    
    func reallyFindMe() {
        switch self.which {
        case 1:
            if self.trying { return }
            self.trying = true
            self.locman.desiredAccuracy = kCLLocationAccuracyBest
            self.locman.distanceFilter = kCLDistanceFilterNone
            self.locman.activityType = .other
            self.locman.pausesLocationUpdatesAutomatically = false
            self.startTime = nil
            print("starting", to:&self.output)
            self.locman.startUpdatingLocation()
        case 2:
            print("requesting", to:&self.output)
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed: \(error)", to:&output)
        self.stopTrying()
    }
    
    @IBAction func stop(_ sender: Any) {
        self.stopTrying()
    }
    
    let REQ_ACC : CLLocationAccuracy = 10
    let REQ_TIME : TimeInterval = 30
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        switch which {
        case 1:
            print("did update location ", to:&output)
            let loc = locations.last!
            let acc = loc.horizontalAccuracy
            let time = loc.timestamp
            let coord = loc.coordinate
            if self.startTime == nil {
                self.startTime = Date()
                return // ignore first attempt
            }
            print("accuracy:", acc, to:&output)
            let elapsed = time.timeIntervalSince(self.startTime)
            if elapsed > REQ_TIME {
                print("This is taking too long", to:&output)
                print("You might be at \(coord.latitude) \(coord.longitude)", to:&output)
                self.stopTrying()
                return
            }
            if acc < 0 || acc > REQ_ACC {
                return // wait for the next one
            }
            // got it
            print("You are at \(coord.latitude) \(coord.longitude)", to:&output)
            self.stopTrying()
        case 2:
            let loc = locations.last!
            let coord = loc.coordinate
            print("The quick way: You are at \(coord.latitude) \(coord.longitude)", to:&output)
            // bug: can be called twice in quick succession
            // ok, the bug is gone; it seems that we just get the cached value the second time
        default: break
        }
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("paused!", to:&output)
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("resumed!", to:&output)
    }

}
