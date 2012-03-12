

#import "MyView3.h"

@implementation MyView3 {
    BOOL decidedDirection;
    BOOL horiz;
    BOOL decidedTapOrDrag;
    BOOL drag;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // be undecided
    self->decidedTapOrDrag = NO;
    // prepare for a tap
    int ct = [[touches anyObject] tapCount];
    if (ct == 2) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(singleTap)
                                                   object:nil];
        self->decidedTapOrDrag = YES;
        self->drag = NO;
        return;
    }
    // prepare for a drag
    self->decidedDirection = NO;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self->decidedTapOrDrag && !self->drag)
        return;
    [self.superview bringSubviewToFront:self];
    self->decidedTapOrDrag = YES;
    self->drag = YES;
    if (!self->decidedDirection) {
        self->decidedDirection = YES;
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


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self->decidedTapOrDrag || !self->drag) {
        // end for a tap
        int ct = [[touches anyObject] tapCount];
        if (ct == 1)
            [self performSelector:@selector(singleTap) withObject:nil 
                       afterDelay:0.3];
        if (ct == 2)
            NSLog(@"double tap");
        return;
    }
}

- (void) singleTap {
    NSLog(@"single tap");
}



@end
