
import UIKit
import MapKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController: UIViewController, MKMapViewDelegate {
    
    let which = 1 // 1...10
    
    @IBOutlet var map : MKMapView!
    var annloc : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map.tintColor = UIColor.greenColor()
        
        let loc = CLLocationCoordinate2DMake(34.927752,-120.217608)
        let span = MKCoordinateSpanMake(0.015, 0.015)
        let reg = MKCoordinateRegionMake(loc, span)
        // or ...
        // let reg = MKCoordinateRegionMakeWithDistance(loc, 1200, 1200)
        self.map.region = reg
        //  or ...
//                let pt = MKMapPointForCoordinate(loc)
//                let w = MKMapPointsPerMeterAtLatitude(loc.latitude) * 1200
//                self.map.visibleMapRect = MKMapRectMake(pt.x - w/2.0, pt.y - w/2.0, w, w)
        
        self.annloc = CLLocationCoordinate2DMake(34.923964,-120.219558)
        
        if which == 1 {
            return
        }
        if which < 6 {
            let ann = MKPointAnnotation()
            ann.coordinate = self.annloc
            ann.title = "Park here"
            ann.subtitle = "Fun awaits down the road!"
            self.map.addAnnotation(ann)
        } else {
            let ann = MyAnnotation(location:self.annloc)
            ann.title = "Park here"
            ann.subtitle = "Fun awaits down the road!"
            self.map.addAnnotation(ann)
            delay(2) {
                UIView.animateWithDuration(0.25) {
                    var loc = ann.coordinate
                    loc.latitude = loc.latitude + 0.0005
                    loc.longitude = loc.longitude + 0.001
                    ann.coordinate = loc
                }
            }
        }
        if which == 8 {
            let lat = self.annloc.latitude
            let metersPerPoint = MKMetersPerMapPointAtLatitude(lat)
            var c = MKMapPointForCoordinate(self.annloc)
            c.x += 150/metersPerPoint
            c.y -= 50/metersPerPoint
            var p1 = MKMapPointMake(c.x, c.y)
            p1.y -= 100/metersPerPoint
            var p2 = MKMapPointMake(c.x, c.y)
            p2.x += 100/metersPerPoint
            var p3 = MKMapPointMake(c.x, c.y)
            p3.x += 300/metersPerPoint
            p3.y -= 400/metersPerPoint
            var pts = [
                p1, p2, p3
            ]
            let tri = MKPolygon(points:&pts, count:3)
            self.map.addOverlay(tri)
        }
        if which == 9 {
            // start with our position and derive a nice unit for drawing
            let lat = self.annloc.latitude
            let metersPerPoint = MKMetersPerMapPointAtLatitude(lat)
            let c = MKMapPointForCoordinate(self.annloc)
            let unit = CGFloat(75.0/metersPerPoint)
            // size and position the overlay bounds on the earth
            let sz = CGSizeMake(4*unit, 4*unit)
            let mr = MKMapRectMake(c.x + 2*Double(unit), c.y - 4.5*Double(unit), Double(sz.width), Double(sz.height))
            // describe the arrow as a CGPath
            let p = CGPathCreateMutable()
            let start = CGPointMake(0, unit*1.5)
            let p1 = CGPointMake(start.x+2*unit, start.y)
            let p2 = CGPointMake(p1.x, p1.y-unit)
            let p3 = CGPointMake(p2.x+unit*2, p2.y+unit*1.5)
            let p4 = CGPointMake(p2.x, p2.y+unit*3)
            let p5 = CGPointMake(p4.x, p4.y-unit)
            let p6 = CGPointMake(p5.x-2*unit, p5.y)
            var points = [
                start, p1, p2, p3, p4, p5, p6
            ]
            // rotate the arrow around its center
            let t1 = CGAffineTransformMakeTranslation(unit*2, unit*2)
            let t2 = CGAffineTransformRotate(t1, CGFloat(-M_PI)/3.5)
            var t3 = CGAffineTransformTranslate(t2, -unit*2, -unit*2)
            CGPathAddLines(p, &t3, &points, 7)
            CGPathCloseSubpath(p)
            // create the overlay and give it the path
            let over = MyOverlay(rect:mr)
            over.path = UIBezierPath(CGPath:p)
            // add the overlay to the map
            self.map.addOverlay(over)
            // println(self.map.overlays)
        }
        if which == 10 {
            
            let lat = self.annloc.latitude
            let metersPerPoint = MKMetersPerMapPointAtLatitude(lat)
            let c = MKMapPointForCoordinate(self.annloc)
            let unit = 75.0/metersPerPoint
            // size and position the overlay bounds on the earth
            let sz = CGSizeMake(4*CGFloat(unit), 4*CGFloat(unit))
            let mr = MKMapRectMake(c.x + 2*unit, c.y - 4.5*unit, Double(sz.width), Double(sz.height))
            let over = MyOverlay(rect:mr)
            self.map.addOverlay(over, level:.AboveRoads)
            
            let annot = MKPointAnnotation()
            annot.coordinate = over.coordinate
            annot.title = "This way!"
            self.map.addAnnotation(annot)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if which == 3 {
            var v : MKAnnotationView! = nil
            if let t = annotation.title where t == "Park here" {
                let ident = "greenPin"
                v = mapView.dequeueReusableAnnotationViewWithIdentifier(ident)
                if v == nil {
                    v = MKPinAnnotationView(annotation:annotation, reuseIdentifier:ident)
                    (v as! MKPinAnnotationView).pinTintColor = MKPinAnnotationView.greenPinColor() // or any UIColor
                    v.canShowCallout = true
                    (v as! MKPinAnnotationView).animatesDrop = true
                    
                }
                v.annotation = annotation
            }
            return v
        }
        if which == 4 {
            var v : MKAnnotationView! = nil
            if let t = annotation.title where t == "Park here" {
                let ident = "bike"
                v = mapView.dequeueReusableAnnotationViewWithIdentifier(ident)
                if v == nil {
                    v = MKAnnotationView(annotation:annotation, reuseIdentifier:ident)
                    v.image = UIImage(named:"clipartdirtbike.gif")
                    v.bounds.size.height /= 3.0
                    v.bounds.size.width /= 3.0
                    v.centerOffset = CGPointMake(0,-20)
                    v.canShowCallout = true
                }
                v.annotation = annotation
            }
            return v
        }
        if which == 5 {
            var v : MKAnnotationView! = nil
            if let t = annotation.title where t == "Park here" {
                let ident = "bike"
                v = mapView.dequeueReusableAnnotationViewWithIdentifier(ident)
                if v == nil {
                    v = MyAnnotationView(annotation:annotation, reuseIdentifier:ident)
                    v.canShowCallout = true
                }
                v.annotation = annotation
            }
            return v
        }
        if which >= 6 {
            var v : MKAnnotationView! = nil
            if annotation is MyAnnotation {
                let ident = "bike"
                v = mapView.dequeueReusableAnnotationViewWithIdentifier(ident)
                if v == nil {
                    v = MyAnnotationView(annotation:annotation, reuseIdentifier:ident)
                    v.canShowCallout = true
                    let im = UIImage(named:"smileyWithTransparencyTiny.png")!
                        .imageWithRenderingMode(.AlwaysTemplate)
                    let iv = UIImageView(image:im)
                    v.leftCalloutAccessoryView = iv
                    v.rightCalloutAccessoryView = UIButton(type:.InfoLight)
                    let lab = UILabel()
                    lab.text = "With a hey and a ho and a hey nonny no!"
                    lab.numberOfLines = 0
                    lab.font = lab.font.fontWithSize(10)
                    v.detailCalloutAccessoryView = lab
                }
                v.annotation = annotation
                v.draggable = true
            }
            return v
        }
        return nil
    }
    
    // is this a bug? we get this message even if the user taps the whole callout,
    // reporting that the button was tapped even though it wasn't
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("tap \(control)")
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        if which >= 7 {
            for aView in views {
                if aView.reuseIdentifier == "bike" {
                    aView.transform = CGAffineTransformMakeScale(0, 0)
                    aView.alpha = 0
                    UIView.animateWithDuration(0.8) {
                        aView.alpha = 1
                        aView.transform = CGAffineTransformIdentity
                    }
                }
            }
        }
    }
    
    // hmm, now returns non-nil MKOverlayRenderer
    // this changes the structure of my code
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if which == 8 {
            if let overlay = overlay as? MKPolygon {
                let v = MKPolygonRenderer(polygon:overlay)
                v.fillColor = UIColor.redColor().colorWithAlphaComponent(0.1)
                v.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.8)
                v.lineWidth = 2
                return v
            }
        }
        if which == 9 {
            if let overlay = overlay as? MyOverlay {
                let v = MKOverlayPathRenderer(overlay:overlay)
                v.path = overlay.path.CGPath
                v.fillColor = UIColor.redColor().colorWithAlphaComponent(0.2)
                v.strokeColor = UIColor.blackColor()
                v.lineWidth = 2
                return v
            }
        }
        if which == 10 {
            if overlay is MyOverlay {
                let v = MyOverlayRenderer(overlay:overlay, angle: -CGFloat(M_PI)/3.5)
                return v
            }
        }
        return MKOverlayRenderer() // ???? why did they make this non-nil?
    }
    
    @IBAction func showPOIinMapsApp (sender:AnyObject) {
        let p = MKPlacemark(coordinate:self.annloc, addressDictionary:nil)
        let mi = MKMapItem(placemark: p)
        mi.name = "A Great Place to Dirt Bike" // label to appear in Maps app
        // setting the span seems to have no effect
        let opts = [
            MKLaunchOptionsMapTypeKey: MKMapType.Standard.rawValue,
//            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate:self.map.region.center),
//            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan:self.map.region.span)
        ]
        mi.openInMapsWithLaunchOptions(opts)
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch (newState) {
        case .Starting:
            view.dragState = .Dragging
        case .Ending, .Canceling:
            view.dragState = .None
        default: break
        }
    }
    
}
