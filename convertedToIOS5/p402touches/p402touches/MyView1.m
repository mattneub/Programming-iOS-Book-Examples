

#import "MyView1.h"

@implementation MyView1 {
    BOOL decided;
    BOOL horiz;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self->decided = NO;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview bringSubviewToFront:self];
    if (!self->decided) {
        self->decided = YES;
        CGPoint then = [[touches anyObject] previousLocationInView: self];
        CGPoint now = [[touches anyObject] locationInView: self];
        CGFloat deltaX = fabs(then.x - now.x);
        CGFloat deltaY = fabs(then.y - now.y);
        self->horiz = (deltaX >= deltaY);
    }
    CGPoint loc = [[touches anyObject] locationInView: self.superview];
    CGPoint oldP = [[touches anyObject] previousLocationInView: self.superview];
    CGFloat deltaX = loc.x - oldP.x;
    CGFloat deltaY = loc.y - oldP.y;
    CGPoint c = self.center;
    if (self->horiz)
        c.x += deltaX;
    else
        c.y += deltaY;
    self.center = c;
}



@end
