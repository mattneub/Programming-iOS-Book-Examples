

import UIKit
import MapKit

class MyAnnotation : NSObject, MKAnnotation {

//@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
    
    let coordinate : CLLocationCoordinate2D
    var title : String!
    var subtitle : String!
    
    init(location coord:CLLocationCoordinate2D) {
        self.coordinate = coord
        super.init()
    }
    
//@property (nonatomic, copy) NSString *title, *subtitle;
//- (id)initWithLocation:(CLLocationCoordinate2D)coord;

}