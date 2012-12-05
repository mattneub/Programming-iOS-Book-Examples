

#import "MyAnnotation.h"


@implementation MyAnnotation


- (id)initWithLocation: (CLLocationCoordinate2D) coord {
    self = [super init];
    if (self) {
        self->_coordinate = coord;
    }
    return self;
}

@end
