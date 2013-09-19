

#import "MyView.h"

@implementation MyView

// the button is a subview of this view... try to tap it

// normally, you can't touch a subview's region outside its superview
// but you can *see* a subview outside its superview if the superview doesn't clip to bounds,
// so why shouldn't you be able to touch it?
// this hitTest override makes it possible
// try the example with hitTest commented out and with it restored to see the difference

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* result = [super hitTest:point withEvent:event];
    if (result)
        return result;
    for (UIView* sub in [self.subviews reverseObjectEnumerator]) {
        CGPoint pt = [self convertPoint:point toView:sub];
        result = [sub hitTest:pt withEvent:event];
        if (result)
            return result;
    }
    return nil;
}

@end
