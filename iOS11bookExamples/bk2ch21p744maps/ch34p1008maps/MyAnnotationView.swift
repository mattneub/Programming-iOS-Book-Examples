
import UIKit
import MapKit

class MyBikeAnnotationView : MKAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            self.image = UIImage(named:"clipartdirtbike.gif")
            self.bounds.size.height /= 3.0
            self.bounds.size.width /= 3.0
            self.centerOffset = CGPoint(0,-20)
            self.canShowCallout = true
        }
    }
    
}
