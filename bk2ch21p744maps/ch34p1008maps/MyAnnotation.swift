import UIKit
import MapKit

class MyBikeAnnotation : NSObject, MKAnnotation {
    dynamic var coordinate : CLLocationCoordinate2D
    /* dynamic */ var title: String?
    var subtitle: String?
    
    init(location coord:CLLocationCoordinate2D) {
        self.coordinate = coord
        super.init()
    }

}
