

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var label: UILabel!
    
    let locman = CLLocationManager()
    var doThisWhenAuthorized : (() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        locman.delegate = self
    }

    @IBAction func doAskForWhenInUse(_ sender: Any) {
        // self.locman.requestWhenInUseAuthorization()
        self.checkForLocationAccess() {
            print("doing something for when in use")
        }
    }
    
    @IBAction func doAskForAlways(_ sender: Any) {
        // self.locman.requestAlwaysAuthorization()
        self.checkForLocationAccess(always:true) {
            print("doing something for always")
        }
    }
    
    func checkForLocationAccess(always:Bool = false, andThen f: (()->())? = nil) {
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
    
    fileprivate func updateStatus(_ status: CLAuthorizationStatus) {
        self.label.text = {
            switch status {
            case .authorizedAlways: return "Always"
            case .authorizedWhenInUse: return "When In Use"
            default: return ""
            }
        }()
    }
    
    @available(iOS 14.0,*)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        print("authorization is", status.rawValue)
        updateStatus(status)
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.doThisWhenAuthorized?()
        }
        self.doThisWhenAuthorized = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("authorization is", status.rawValue)
    }

    @available(iOS 14.0,*)
    @IBAction func doStatus(_ sender: Any) {
        self.updateStatus(self.locman.authorizationStatus)
    }
}

