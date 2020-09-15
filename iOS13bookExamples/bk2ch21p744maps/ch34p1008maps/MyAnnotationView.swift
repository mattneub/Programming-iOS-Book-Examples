
import UIKit
import MapKit

class MyBikeAnnotationView : MKAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            self.image = UIImage(named:"clipartdirtbike.gif")
            // why do I have to change this? suddenly we have to take scale into account?
            // and why does this work differently on device (right) from simulator (wrong)?
            let scale = UIScreen.main.scale
            self.bounds.size.height /= 3.0 / scale
            self.bounds.size.width /= 3.0 / scale
            self.centerOffset = CGPoint(0,-20)
            self.canShowCallout = true
        }
    }
    
}
