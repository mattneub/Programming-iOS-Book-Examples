

#import "MyView1.h"

@implementation MyView1 {
    CGPoint p;
    CGPoint origC;
    BOOL decided;
    BOOL horiz;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self->p = [[touches anyObject] locationInView: self.superview];
    self->origC = self.center;
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
    CGFloat deltaX = loc.x - self->p.x;
    CGFloat deltaY = loc.y - self->p.y;
    CGPoint c = self.center;
    if (self->horiz)
        c.x = self->origC.x + deltaX;
    else
        c.y = self->origC.y + deltaY;
    self.center = c;
    self->p = [[touches anyObject] locationInView: self.superview];
    self->origC = self.center;
}



@end
