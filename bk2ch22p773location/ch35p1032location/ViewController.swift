
import UIKit
import CoreLocation

class ManagerHolder {
    let locman = CLLocationManager()
    var doThisWhenAuthorized : (() -> ())?
    func checkForLocationAccess(always: Bool=false, andThen f: (()->())?=nil) {
        // no services? fail but try get alert
        guard CLLocationManager.locationServicesEnabled() else {
            print("no location services")
            self.locman.startUpdatingLocation()
            return
        }
        // new in iOS 14, use instance method, not class method
        var status: CLAuthorizationStatus!
        if #available(iOS 14.0,*) {
            status = self.locman.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        switch status {
        case .authorizedWhenInUse:
            if always { // try to step up
                print("trying to step up")
                self.doThisWhenAuthorized = f
                self.locman.requestAlwaysAuthorization()
            } else {
                f?()
            }
        case .authorizedAlways:
            f?()
        case .notDetermined:
            self.doThisWhenAuthorized = f
            if always {
                print("asking for always")
                self.locman.requestAlwaysAuthorization()
            } else {
                print("asking for when in use")
                self.locman.requestWhenInUseAuthorization()
            }
        case .restricted:
            print("restricted")
            break
        case .denied:
            print("denied")
            break
        default: fatalError()
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
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.locman.delegate = self
    }
    
    var startTime : Date!
    var trying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(goingIntoBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(comingIntoForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        return;
        // for screen shots
        let v = UIView()
        v.backgroundColor = .white
        v.frame = self.view.bounds
        self.view.addSubview(v)
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.testWhenInUseRequest(self)
    }
    
    
    @objc func goingIntoBackground(_ n:Notification) {
        let status : CLAuthorizationStatus = {
            if #available(iOS 14.0,*) {
                return self.locman.authorizationStatus
            } else {
                return CLLocationManager.authorizationStatus()
            }
        }()
        if status == .authorizedWhenInUse {
            self.locman.allowsBackgroundLocationUpdates = true // test background loc
        }
        if status == .authorizedAlways {
            if CLLocationManager.significantLocationChangeMonitoringAvailable() {
                print("start visit monitoring", to: &output)
                self.locman.startMonitoringVisits() // test background monitoring
                // self.locman.showsBackgroundLocationIndicator = true // test blue bar
            } else {
                print("no significant change monitoring, sorry", to: &output)
            }
        }
    }
    
    @objc func comingIntoForeground(_ n:Notification) {
        self.locman.allowsBackgroundLocationUpdates = false
        self.locman.stopMonitoringVisits()
    }


    // deprecated:
    // func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // if you implement both, the new one is called in iOS 14
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status : CLAuthorizationStatus = {
            if #available(iOS 14.0,*) {
                return self.locman.authorizationStatus
            } else {
                return CLLocationManager.authorizationStatus()
            }
        }()
        print("authorization is", status.rawValue, to: &output)
        if #available(iOS 14.0,*) {
            print("accuracy is: \(manager.accuracyAuthorization.rawValue)", to: &output)
        }
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.managerHolder.doThisWhenAuthorized?()
        }
        self.managerHolder.doThisWhenAuthorized = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print(String(describing:visit), to:&output)
    }
    
    var which = 0
    
    @IBAction func testWhenInUseRequest (_ sender: Any) {
        self.managerHolder.checkForLocationAccess()
    }
    
    @IBAction func testAlwaysRequest (_ sender: Any) {
        self.managerHolder.checkForLocationAccess(always:true)
    }
    
    @IBAction func testPrecisionRequest(_ sender: Any) {
        if #available(iOS 14.0,*) {
            self.locman.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "ExactTracking") { err in
                
            }
        }
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
    
    @IBAction func reportStatus(_ sender: Any) {
        let status : CLAuthorizationStatus = {
            if #available(iOS 14.0,*) {
                return self.locman.authorizationStatus
            } else {
                return CLLocationManager.authorizationStatus()
            }
        }()
        print("auth is: \(status.rawValue)", to:&output)
        if #available(iOS 14.0,*) {
            print("accuracy is: \(self.locman.accuracyAuthorization.rawValue)", to: &output)
        }
    }
    
    // NB new in iOS 14, kCLLocationAccuracyReduced is a thing
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
        self.locman.stopMonitoringVisits()
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
                // if reduced accuracy, don't ignore the first one, as the second one will be a long time coming!
                if #available(iOS 14.0,*) {
                    if manager.accuracyAuthorization != .reducedAccuracy {
                        return // ignore first attempt
                    }
                } else {
                    return // ignore first attempt
                }
            }
            print("accuracy:", acc, to:&output)
            let elapsed = time.timeIntervalSince(self.startTime)
            if elapsed > REQ_TIME {
                print("This is taking too long", to:&output)
                print("You might be at \(coord.latitude) \(coord.longitude)", to:&output)
                self.stopTrying()
                return
            }
            if #available(iOS 14.0,*) {
                if manager.accuracyAuthorization != .reducedAccuracy {
                    if acc < 0 || acc > REQ_ACC {
                        return // wait for the next one
                    }
                }
            } else {
                if acc < 0 || acc > REQ_ACC {
                    return // wait for the next one
                }
            }
            // got it
            print("You are at \(coord.latitude) \(coord.longitude)", to:&output)
            //self.stopTrying()
        case 2:
            let loc = locations.last!
            let coord = loc.coordinate
            print("The quick way: You are at \(coord.latitude) \(coord.longitude)", to:&output)
            // bug: can be called twice in quick succession
            // ok, the bug is gone; it seems that we just get the cached value the second time
            // but these do keep arriving! is that a bug?
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
