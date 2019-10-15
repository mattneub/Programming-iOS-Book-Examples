
import UIKit
import MapKit
import Contacts

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    @IBOutlet var map : MKMapView!
    let locman = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bbi = MKUserTrackingBarButtonItem(mapView:self.map)
        self.toolbarItems = [bbi]
        
        let sb = UISearchBar()
        sb.sizeToFit()
        sb.searchBarStyle = .minimal
        sb.delegate = self
        self.navigationItem.titleView = sb
        
        self.map.delegate = self
        
    }
    
    @IBAction func doButton (_ sender: Any) {
        let mi = MKMapItem.forCurrentLocation()
        // here, however, it seems that we cannot set the span...?
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        mi.openInMaps(launchOptions:[
            MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue,
            // whoa, in iOS 13 you crash if you try passing a coordinate span
            // okay, you can avoid the crash by making an NSValue yourself
            // but it still doesn't _do_ anything
            // MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: span)
        ])
    }
    
    @IBAction func doButton2 (_ sender: Any) {
        // new in iOS 8, can't simply switch this on
        // must request authorization first
        // and this request will be ignored without a corresponding reason in the Info.plist
        // (see next chapter for full dance)
        self.locman.requestWhenInUseAuthorization()
        // self.map.showsUserLocation = true // otiose (I love that word)
        self.map.userTrackingMode = .follow // will cause map to zoom nicely to user location
        // (the thing I was doing before, adjusting the map region manually, was just wrong)
    }

    @IBAction func reportAddress (_ sender: Any) {
        guard let loc = self.map.userLocation.location else {
            print("I don't know where you are now")
            return
        }
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(loc) { placemarks, error in
            guard let ps = placemarks, ps.count > 0 else {return}
            let p = ps[0]
            // addressDictionary is now deprecated,
            // and where are we supposed to get a substitute?
            // aha! import Contacts and now you can use the `postalAddress`
            if let addy = p.postalAddress {
                let f = CNPostalAddressFormatter()
                print(f.string(from: addy))
                print(addy.street)
                print(addy.city)
                print(addy.state)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let s = searchBar.text else { return }
        guard s.count > 5 else { return }
        let geo = CLGeocoder()
        geo.geocodeAddressString(s) { placemarks, error in
            guard let placemarks = placemarks else {
                print(error?.localizedDescription as Any)
                return
            }
            self.map.showsUserLocation = false
            let p = placemarks[0]
            let mp = MKPlacemark(placemark:p)
            self.map.removeAnnotations(self.map.annotations)
            self.map.addAnnotation(mp)
            self.map.setRegion(
                MKCoordinateRegion(center: mp.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000),
                animated: true)
        }
    }
    
    @IBAction func thaiFoodNearMapLocation (_ sender: Any) {
        guard let loc = self.map.userLocation.location else {
            print("I don't know where you are now")
            return
        }
        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = "Thai"
        req.region = MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 1,longitudeDelta: 1))
        req.resultTypes = .pointOfInterest
        let filter = MKPointOfInterestFilter(including: [.restaurant])
        req.pointOfInterestFilter = filter
        let search = MKLocalSearch(request:req)
        search.start { response, error in
            guard let response = response else {
                print(error as Any)
                return
            }
            self.map.showsUserLocation = false
            let mi = response.mapItems[0] // I'm feeling lucky
            print(response.mapItems)
            let place = mi.placemark
            let loc = place.location!.coordinate
            let reg = MKCoordinateRegion(center: loc, latitudinalMeters: 1200, longitudinalMeters: 1200)
            self.map.setRegion(reg, animated:true)
            let ann = MKPointAnnotation()
            ann.title = mi.name
            ann.subtitle = mi.phoneNumber
            ann.coordinate = loc
            self.map.addAnnotation(ann)
            self.map.pointOfInterestFilter = filter
        }
    }
    
    @IBAction func directionsToThaiFood (_ sender: Any) {
        let userLoc = self.map.userLocation
        let loc = userLoc.location
        if loc == nil {
            print("I don't know where you are now")
            return
        }
        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = "Thai restaurant"
        req.region = self.map.region
        let search = MKLocalSearch(request:req)
        search.start { response, error in
            guard let response = response else {
                print(error as Any)
                return
            }
            print("Got restaurant address")
            let mi = response.mapItems[0] // I'm still feeling lucky
            let req = MKDirections.Request()
            req.source = MKMapItem.forCurrentLocation()
            req.destination = mi
            let dir = MKDirections(request:req)
            dir.calculate { response, error in
                guard let response = response else {
                    print(error as Any)
                    return
                }
                print("got directions")
                let route = response.routes[0] // I'm feeling insanely lucky
                let poly = route.polyline
                self.map.addOverlay(poly)
                for step in route.steps {
                    print("After \(step.distance) metres: \(step.instructions)")
                }
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKPolyline {
            let r = MKPolylineRenderer(polyline:overlay)
            r.strokeColor = UIColor.blue.withAlphaComponent(0.8)
            r.lineWidth = 2
            return r
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print(type(of:annotation))
        if let annotation = annotation as? MKUserLocation {
            annotation.title = "You are here, stupid!"
            return nil
            let v = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
            return v
        }
        return nil // default
    }
    
    private func mapViewNOT(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        userLocation.title = "You are lost!"
    }
    
}
