

#import "CompassView.h"
#import "CompassLayer.h"

@implementation CompassView

+ (Class) layerClass { 
    return [CompassLayer class];
}

- (IBAction) tapped: (UITapGestureRecognizer*) t {
    CGPoint p = [t locationOfTouch: 0 inView: self.superview];
    CALayer* hitLayer = [self.layer hitTest:p];
    CALayer* arrow = ((CompassLayer*)self.layer).arrow;
    if (hitLayer == arrow) {
        arrow.transform = CATransform3DRotate(arrow.transform, M_PI/4.0, 0, 0, 1);
    }
}

@end
