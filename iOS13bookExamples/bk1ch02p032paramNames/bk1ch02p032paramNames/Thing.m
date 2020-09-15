
#import "Thing.h"

@implementation Thing

- (Thing*) thingByCrushingInstancesOfThing: (Thing*) otherThing {
    return [Thing new];
}

@end
