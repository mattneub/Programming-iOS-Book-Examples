

import UIKit
import MapKit

class MyOverlay : NSObject, MKOverlay {
    
    var coordinate : CLLocationCoordinate2D {
        get {
            let pt = MKMapPointMake(MKMapRectGetMidX(self.boundingMapRect), MKMapRectGetMidY(self.boundingMapRect))
            return MKCoordinateForMapPoint(pt)
        }
    }
    
    var boundingMapRect : MKMapRect
    var path : UIBezierPath!
    
    init(rect:MKMapRect) {
        self.boundingMapRect = rect
        super.init()
    }
    
}
