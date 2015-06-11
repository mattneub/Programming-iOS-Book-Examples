

#import "MyLayer.h"

@implementation MyLayer

// @dynamic can't be expressed in Swift...
// ...so we need to express it in Objective-C
// (Swift "dynamic" exists but it isn't sufficient to allow implicit animation:
// if we don't declare it in Objective-C, our actionForKey won't be called for it)

@dynamic thickness;

// copied from Apple's example, but I don't see how it helps in this situation

-(id)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if ([layer isKindOfClass:[MyLayer class]])
        self.thickness = ((MyLayer*)layer).thickness;
    return self;
}


@end
