
#import "MyOverlay.h"


@implementation MyOverlay

@synthesize boundingMapRect, coordinate, path;

- (void)dealloc {
    [path release];
    [super dealloc];
}

- (id) initWithRect: (MKMapRect) rect {
    self = [super init];
    if (self) {
        self->boundingMapRect = rect;
    }
    return self;
}


@end
