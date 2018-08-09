
import UIKit
import MapKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class ViewController: UIViewController, MKMapViewDelegate {
    
    let which = 2 // 1...10
    
    @IBOutlet var map : MKMapView!
    let annloc = CLLocationCoordinate2DMake(34.923964,-120.219558)

    
    let bikeid = "bike"
    let bikeid2 = "bike2"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: self.bikeid)
        self.map.register(MyBikeAnnotationView.self, forAnnotationViewWithReuseIdentifier: self.bikeid2)

        self.map.tintColor = .green
        
        let loc = CLLocationCoordinate2DMake(34.927752,-120.217608)
        let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        let reg = MKCoordinateRegion(center: loc, span: span)
        // or ...
        // let reg = MKCoordinateRegionMakeWithDistance(loc, 1200, 1200)
        self.map.region = reg
        //  or ...
        do {
            let pt = MKMapPoint(loc)
            let w = MKMapPointsPerMeterAtLatitude(loc.latitude) * 1200
            _ = MKMapRect(x: pt.x - w/2.0, y: pt.y - w/2.0, width: w, height: w)
            let p2 = MKMapPoint(loc)
            _ = pt.distance(to:p2)
            _ = MKMetersPerMapPointAtLatitude(loc.latitude)
        }
        
        // try new iOS 11 feature
        self.map.showsCompass = false
        let compass = MKCompassButton(mapView:self.map)
        compass.frame.origin = CGPoint(20,400)
        // compass.compassVisibility = .visible
        compass.isHidden = true // prevent annoying initial flash
        self.view.addSubview(compass)
        

        
        if which == 1 {
            // try snapshot feature
            delay(2) {
                let opts = MKMapSnapshotter.Options()
                opts.region = self.map.region
                let snap = MKMapSnapshotter(options: opts)
                snap.start { shot, err in
                    if let shot = shot {
                        let im = shot.image
                        print(im)
                    }
                }
            }

            return
        }
        if which < 6 {
            let ann = MKPointAnnotation()
            ann.coordinate = self.annloc
            ann.title = "Park here"
            ann.subtitle = "Fun awaits down the road!"
            self.map.addAnnotation(ann)
        } else {
            let ann = MyBikeAnnotation(location:self.annloc)
            ann.title = "Park here"
            ann.subtitle = "Fun awaits down the road!"
            self.map.addAnnotation(ann)
            delay(2) {
                UIView.animate(withDuration:0.25) {
                    var loc = ann.coordinate
                    loc.latitude = loc.latitude + 0.0005
                    loc.longitude = loc.longitude + 0.001
                    ann.coordinate = loc
                    ann.title = "I mean here" // testing whether callout sees change
                    // ok, I see what Rob means http://stackoverflow.com/questions/41469459/can-i-assign-different-images-to-every-pin-in-the-map/41469583#comment70150742_41469583
                    // it's only an issue if the callout is _open_ when title changes
                    // for that to work, title must be declared dynamic
                }
            }
        }
        if which == 8 {
            let lat = self.annloc.latitude
            let metersPerPoint = MKMetersPerMapPointAtLatitude(lat)
            var c = MKMapPoint(self.annloc)
            c.x += 150/metersPerPoint
            c.y -= 50/metersPerPoint
            var p1 = MKMapPoint(x: c.x, y: c.y)
            p1.y -= 100/metersPerPoint
            var p2 = MKMapPoint(x: c.x, y: c.y)
            p2.x += 100/metersPerPoint
            var p3 = MKMapPoint(x: c.x, y: c.y)
            p3.x += 300/metersPerPoint
            p3.y -= 400/metersPerPoint
            var points = [p1, p2, p3]
            let tri = MKPolygon(points:&points, count:3)
            self.map.addOverlay(tri)
        }
        if which == 9 {
            // start with our position and derive a nice unit for drawing
            let lat = self.annloc.latitude
            let metersPerPoint = MKMetersPerMapPointAtLatitude(lat)
            let c = MKMapPoint(self.annloc)
            let unit = CGFloat(75.0/metersPerPoint)
            // size and position the overlay bounds on the earth
            let sz = CGSize(4*unit, 4*unit)
            let mr = MKMapRect(x: c.x + 2*Double(unit), y: c.y - 4.5*Double(unit), width: Double(sz.width), height: Double(sz.height))
            // describe the arrow as a CGPath
            let p = CGMutablePath()
            let start = CGPoint(0, unit*1.5)
            let p1 = CGPoint(start.x+2*unit, start.y)
            let p2 = CGPoint(p1.x, p1.y-unit)
            let p3 = CGPoint(p2.x+unit*2, p2.y+unit*1.5)
            let p4 = CGPoint(p2.x, p2.y+unit*3)
            let p5 = CGPoint(p4.x, p4.y-unit)
            let p6 = CGPoint(p5.x-2*unit, p5.y)
            let points = [start, p1, p2, p3, p4, p5, p6]
            // rotate the arrow around its center
            let t1 = CGAffineTransform(translationX: unit*2, y: unit*2)
            let t2 = t1.rotated(by:-.pi/3.5)
            let t3 = t2.translatedBy(x: -unit*2, y: -unit*2)
            p.addLines(between: points, transform: t3)
            p.closeSubpath()
            // create the overlay and give it the path
            let over = MyPathOverlay(rect:mr)
            over.path = UIBezierPath(cgPath:p)
            // add the overlay to the map
            self.map.addOverlay(over)
            // print(self.map.overlays)
        }
        if which == 10 {
            
            let lat = self.annloc.latitude
            let metersPerPoint = MKMetersPerMapPointAtLatitude(lat)
            let c = MKMapPoint(self.annloc)
            let unit = 75.0/metersPerPoint
            // size and position the overlay bounds on the earth
            let sz = CGSize(4*CGFloat(unit), 4*CGFloat(unit))
            let mr = MKMapRect(x: c.x + 2*unit, y: c.y - 4.5*unit, width: Double(sz.width), height: Double(sz.height))
            let over = MyPathOverlay(rect:mr)
            self.map.addOverlay(over, level:.aboveRoads)
            
            let annot = MKPointAnnotation()
            annot.coordinate = over.coordinate
            annot.title = "This way!"
            self.map.addAnnotation(annot)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if which == 3 {
            let id = MKMapViewDefaultAnnotationViewReuseIdentifier
            if let v = mapView.dequeueReusableAnnotationView(withIdentifier: id, for: annotation) as? MKMarkerAnnotationView {
                if let t = annotation.title, t == "Park here" {
                    v.titleVisibility = .visible
                    v.subtitleVisibility = .visible
                    v.markerTintColor = .green
                    v.glyphText = "!"
                    // v.glyphImage = UIImage(named:"smileyWithTransparencyTiny")!.withRenderingMode(.alwaysOriginal)
                    v.glyphTintColor = .black
                    // v.animatesWhenAdded = true
                    v.isDraggable = true
                    print("tried to make it draggable")
                    return v
                }
            }
            return nil
        }
        if which == 4 {
            let v = mapView.dequeueReusableAnnotationView(withIdentifier: self.bikeid, for: annotation)
            if let t = annotation.title, t == "Park here" {
                v.image = UIImage(named:"clipartdirtbike.gif")
                v.bounds.size.height /= 3.0
                v.bounds.size.width /= 3.0
                v.centerOffset = CGPoint(0,-20)
                v.canShowCallout = true
                return v
            }
            return nil
        }
        if which == 5 {
            let v = mapView.dequeueReusableAnnotationView(withIdentifier: self.bikeid2, for: annotation)
            if let t = annotation.title, t == "Park here" {
                // nothing to do!
                return v
            }
            return nil
        }
        if which >= 6 {
            if annotation is MyBikeAnnotation {
                let v = mapView.dequeueReusableAnnotationView(withIdentifier: self.bikeid2, for: annotation)
                let im = UIImage(named:"smileyWithTransparencyTiny.png")!
                    .withRenderingMode(.alwaysTemplate)
                let iv = UIImageView(image:im)
                v.leftCalloutAccessoryView = iv
                v.rightCalloutAccessoryView = UIButton(type:.infoLight)
                let lab = UILabel()
                lab.text = "With a hey and a ho and a hey nonny no!"
                lab.numberOfLines = 0
                lab.font = lab.font.withSize(10)
                v.detailCalloutAccessoryView = lab
                v.isDraggable = true
                print("tried to make it draggable")
                return v
            }
            return nil
        }
        return nil
    }
    
    // is this a bug? we get this message even if the user taps the whole callout,
    // reporting that the button was tapped even though it wasn't
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("tap \(control)")
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if which >= 7 {
            for aView in views {
                if aView.reuseIdentifier == self.bikeid2 {
                    aView.transform = CGAffineTransform(scaleX: 0, y: 0)
                    aView.alpha = 0
                    UIView.animate(withDuration:0.8) {
                        aView.alpha = 1
                        aView.transform = .identity
                    }
                }
            }
        }
    }
    
    // hmm, now returns non-nil MKOverlayRenderer [I've filed a bug]
    // this changes the structure of my code
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if which == 8 {
            if let overlay = overlay as? MKPolygon {
                let r = MKPolygonRenderer(polygon:overlay)
                r.fillColor = UIColor.red.withAlphaComponent(0.1)
                r.strokeColor = UIColor.red.withAlphaComponent(0.8)
                r.lineWidth = 2
                return r
            }
        }
        if which == 9 {
            if let overlay = overlay as? MyPathOverlay {
                let r = MKOverlayPathRenderer(overlay:overlay)
                r.path = overlay.path.cgPath
                r.fillColor = UIColor.red.withAlphaComponent(0.2)
                r.strokeColor = .black
                r.lineWidth = 2
                return r
            }
        }
        if which == 10 {
            if overlay is MyPathOverlay {
                let r = MyPathOverlayRenderer(overlay:overlay, angle: -.pi/3.5)
                return r
            }
        }
        return MKOverlayRenderer() // ???? why did they make this non-nil?
    }
    
    @IBAction func showPOIinMapsApp (_ sender: Any) {
        let p = MKPlacemark(coordinate:self.annloc, addressDictionary:nil)
        let mi = MKMapItem(placemark: p)
        mi.name = "A Great Place to Dirt Bike" // label to appear in Maps app
        // this now works!
        print(MKMapItemTypeIdentifier)
        print(MKMapType.standard.rawValue)
        mi.openInMaps(launchOptions:[
            MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue,
            MKLaunchOptionsMapCenterKey: self.map.region.center,
            MKLaunchOptionsMapSpanKey: self.map.region.span
        ])
        
    }
    
    // this is no longer needed! my views are draggable as long as `isDraggable` is true
    private func mapViewNOT(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        print("here")
        switch newState {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
        default: break
        }
    }
    
}
