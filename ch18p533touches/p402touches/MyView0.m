
#import "MyView0.h"

@implementation MyView0


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview bringSubviewToFront:self];

    CGPoint loc = [[touches anyObject] locationInView: self.superview];
    CGPoint oldP = [[touches anyObject] previousLocationInView: self.superview];
    CGFloat deltaX = loc.x - oldP.x;
    CGFloat deltaY = loc.y - oldP.y;
    CGPoint c = self.center;
    c.x += deltaX;
    c.y += deltaY;
    self.center = c;
}


@end
