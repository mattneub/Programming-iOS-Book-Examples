
#import "MyOverlay.h"


@implementation MyOverlay



- (id) initWithRect: (MKMapRect) rect {
    self = [super init];
    if (self) {
        self->_boundingMapRect = rect;
    }
    return self;
}

- (CLLocationCoordinate2D) coordinate {
    MKMapPoint pt = MKMapPointMake(MKMapRectGetMidX(self.boundingMapRect), MKMapRectGetMidY(self.boundingMapRect));
    return MKCoordinateForMapPoint(pt);
}


@end
