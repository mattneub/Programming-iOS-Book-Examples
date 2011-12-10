

#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyView {
    IBOutlet UIView* v;
}

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // comment out this next line to use our munged hit-testing
    // return [super hitTest:point withEvent:event];
    // v is the animated subview
    CALayer* lay = [v.layer presentationLayer];
    CALayer* hitLayer = [lay hitTest: point];
    if (hitLayer == lay || hitLayer.superlayer == lay) {
        //NSLog(@"hit");
        return v;
    }
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView == v)
        return self;
    return hitView;
}


@end
