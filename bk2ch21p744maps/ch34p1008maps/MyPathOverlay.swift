

import UIKit
import MapKit

class MyPathOverlay : NSObject, MKOverlay {
    
    var coordinate : CLLocationCoordinate2D {
        get {
            let pt = MKMapPoint(x: self.boundingMapRect.midX, y: self.boundingMapRect.midY)
            return pt.coordinate
        }
    }
    
    var boundingMapRect : MKMapRect
    var path : UIBezierPath!
    
    init(rect:MKMapRect) {
        self.boundingMapRect = rect
        super.init()
    }
    
}
