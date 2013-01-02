

#import "MyView1.h"

@implementation MyView1 {
    BOOL _decided;
    BOOL _horiz;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self->_decided = NO;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview bringSubviewToFront:self];
    if (!self->_decided) {
        self->_decided = YES;
        CGPoint then = [[touches anyObject] previousLocationInView: self];
        CGPoint now = [[touches anyObject] locationInView: self];
        CGFloat deltaX = fabs(then.x - now.x);
        CGFloat deltaY = fabs(then.y - now.y);
        self->_horiz = (deltaX >= deltaY);
    }
    CGPoint loc = [[touches anyObject] locationInView: self.superview];
    CGPoint oldP = [[touches anyObject] previousLocationInView: self.superview];
    CGFloat deltaX = loc.x - oldP.x;
    CGFloat deltaY = loc.y - oldP.y;
    CGPoint c = self.center;
    if (self->_horiz)
        c.x += deltaX;
    else
        c.y += deltaY;
    self.center = c;
}



@end
