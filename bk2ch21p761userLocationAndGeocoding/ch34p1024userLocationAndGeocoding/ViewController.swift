
import UIKit
import MapKit
import AddressBookUI

class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    @IBOutlet var map : MKMapView!
    let locman = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bbi = MKUserTrackingBarButtonItem(mapView:self.map)
        self.toolbarItems = [bbi]
        
        let sb = UISearchBar()
        sb.sizeToFit()
        sb.searchBarStyle = .Minimal
        sb.delegate = self
        self.navigationItem.titleView = sb
        
        self.map.delegate = self
    }
    
    @IBAction func doButton (sender:AnyObject!) {
        let mi = MKMapItem.mapItemForCurrentLocation()
        // setting the span doesn't seem to work
        // let span = MKCoordinateSpanMake(0.0005, 0.0005)
        mi.openInMapsWithLaunchOptions([
            MKLaunchOptionsMapTypeKey: MKMapType.Standard.rawValue,
            // MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan:span)
            ])
    }
    
    @IBAction func doButton2 (sender:AnyObject!) {
        // new in iOS 8, can't simply switch this on
        // must request authorization first
        // and this request will be ignored without a corresponding reason in the Info.plist
        // (see next chapter for full dance)
        self.locman.requestWhenInUseAuthorization()
        // self.map.showsUserLocation = true // otiose (I love that word)
        self.map.userTrackingMode = .Follow // will cause map to zoom nicely to user location
        // (the thing I was doing before, adjusting the map region manually, was just wrong)
    }

    @IBAction func reportAddress (sender:AnyObject!) {
        let loc = self.map.userLocation.location
        if loc == nil {
            println("I don't know where you are now")
            return
        }
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(loc) {
            (placemarks : [AnyObject]!, error : NSError!) in
            if placemarks != nil {
                let p = placemarks[0] as! CLPlacemark
                let s = ABCreateStringWithAddressDictionary(p.addressDictionary, false)
                println("you are at:\n\(s)") // do something with address
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let s = searchBar.text
        if s == nil || count(s) < 5 { return }
        let geo = CLGeocoder()
        geo.geocodeAddressString(s) {
            (placemarks : [AnyObject]!, error : NSError!) in
            if nil == placemarks {
                println(error.localizedDescription)
                return
            }
            self.map.showsUserLocation = false
            let p = placemarks[0] as! CLPlacemark
            let mp = MKPlacemark(placemark:p)
            self.map.removeAnnotations(self.map.annotations)
            self.map.addAnnotation(mp)
            self.map.setRegion(
                MKCoordinateRegionMakeWithDistance(mp.coordinate, 1000, 1000),
                animated: true)
        }
    }
    
    @IBAction func thaiFoodNearMapLocation (sender:AnyObject!) {
        let userLoc = self.map.userLocation
        let loc = userLoc.location
        if loc == nil {
            println("I don't know where you are now")
            return
        }
        let req = MKLocalSearchRequest()
        req.naturalLanguageQuery = "Thai restaurant"
        req.region = MKCoordinateRegionMake(loc.coordinate, MKCoordinateSpanMake(1,1))
        let search = MKLocalSearch(request:req)
        search.startWithCompletionHandler() {
            (response : MKLocalSearchResponse!, error : NSError!) in
            if response == nil {
                println(error)
                return
            }
            self.map.showsUserLocation = false
            let mi = response.mapItems[0] as! MKMapItem // I'm feeling lucky
            let place = mi.placemark
            let loc = place.location.coordinate
            let reg = MKCoordinateRegionMakeWithDistance(loc, 1200, 1200)
            self.map.setRegion(reg, animated:true)
            let ann = MKPointAnnotation()
            ann.title = mi.name
            ann.subtitle = mi.phoneNumber
            ann.coordinate = loc
            self.map.addAnnotation(ann)
        }
    }
    
    @IBAction func directionsToThaiFood (sender:AnyObject!) {
        let userLoc = self.map.userLocation
        let loc = userLoc.location
        if loc == nil {
            println("I don't know where you are now")
            return
        }
        let req = MKLocalSearchRequest()
        req.naturalLanguageQuery = "Thai restaurant"
        req.region = self.map.region
        let search = MKLocalSearch(request:req)
        search.startWithCompletionHandler() {
            (response : MKLocalSearchResponse!, error : NSError!) in
            if response == nil {
                println(error)
                return
            }
            println("Got restaurant address")
            let mi = response.mapItems[0] as! MKMapItem // I'm still feeling lucky
            let req = MKDirectionsRequest()
            req.setSource(MKMapItem.mapItemForCurrentLocation())
            req.setDestination(mi)
            let dir = MKDirections(request:req)
            dir.calculateDirectionsWithCompletionHandler() {
                (response:MKDirectionsResponse!, error:NSError!) in
                if response == nil {
                    println(error)
                    return
                }
                println("got directions")
                let route = response.routes[0] as! MKRoute // I'm feeling insanely lucky
                let poly = route.polyline
                self.map.addOverlay(poly)
                for step in route.steps {
                    println("After \(step.distance) metres: \(step.instructions)")
                }
            }
        }
    }

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        var v : MKPolylineRenderer! = nil
        if let overlay = overlay as? MKPolyline {
            v = MKPolylineRenderer(polyline:overlay)
            v.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.8)
            v.lineWidth = 2
        }
        return v
    }
    
}
