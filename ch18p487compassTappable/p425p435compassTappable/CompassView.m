

#import "CompassView.h"
#import "CompassLayer.h"

@implementation CompassView


+ (Class) layerClass { 
    return [CompassLayer class];
}

- (void) awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer* t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:t];
}

// hit-testing for layers
// tap on the arrow, it responds by rotating a little
// see also CompassLayer.m

- (void) tap: (UITapGestureRecognizer*) t {
    // self is the CompassView
    CGPoint p = [t locationOfTouch: 0 inView: self.superview];
    CALayer* hit = [self.layer hitTest:p];
    if (hit == ((CompassLayer*)self.layer).arrow) {
        [(CompassLayer*)self.layer rotateArrow];
    }
}


@end
