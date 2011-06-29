

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize coordinate, title, subtitle;

- (void)dealloc {
    [title release];
    [subtitle release];
    [super dealloc];
}

- (id)initWithLocation: (CLLocationCoordinate2D) coord {
    self = [super init];
    if (self) {
        self->coordinate = coord;
    }
    return self;
}

@end
