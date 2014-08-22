

import UIKit
import MapKit

class MyOverlay : NSObject, MKOverlay {
    
    var coordinate : CLLocationCoordinate2D {
        get {
            let pt = MKMapPointMake(MKMapRectGetMidX(self.boundingMapRect), MKMapRectGetMidY(self.boundingMapRect))
            return MKCoordinateForMapPoint(pt)
        }
    }
    
    private let realBoundingMapRect : MKMapRect
    var boundingMapRect : MKMapRect {
        get {
            return realBoundingMapRect
        }
    }
    var path : UIBezierPath!
    
    init(rect:MKMapRect) {
        self.realBoundingMapRect = rect
        super.init()
    }
    
}
