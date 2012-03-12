

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize coordinate, title, subtitle;


- (id)initWithLocation: (CLLocationCoordinate2D) coord {
    self = [super init];
    if (self) {
        self->coordinate = coord;
    }
    return self;
}

@end
