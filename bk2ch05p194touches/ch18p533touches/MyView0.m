
#import "MyView0.h"

@implementation MyView0


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview bringSubviewToFront:self];

    UITouch* t = touches.anyObject;
    CGPoint loc = [t locationInView: self.superview];
    CGPoint oldP = [t previousLocationInView: self.superview];
    CGFloat deltaX = loc.x - oldP.x;
    CGFloat deltaY = loc.y - oldP.y;
    CGPoint c = self.center;
    c.x += deltaX;
    c.y += deltaY;
    self.center = c;
}


@end
