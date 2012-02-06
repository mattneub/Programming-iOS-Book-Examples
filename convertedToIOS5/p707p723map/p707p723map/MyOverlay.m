
#import "MyOverlay.h"


@implementation MyOverlay

@synthesize boundingMapRect, coordinate, path;


- (id) initWithRect: (MKMapRect) rect {
    self = [super init];
    if (self) {
        self->boundingMapRect = rect;
    }
    return self;
}

- (CLLocationCoordinate2D) coordinate {
    MKMapPoint pt = MKMapPointMake(MKMapRectGetMidX(self->boundingMapRect), MKMapRectGetMidY(self->boundingMapRect));
    return MKCoordinateForMapPoint(pt);
}


@end
