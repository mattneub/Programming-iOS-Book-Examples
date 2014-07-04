

#import "MyView3.h"

@implementation MyView3 {
    BOOL _decidedDirection;
    BOOL _horiz;
    BOOL _decidedTapOrDrag;
    BOOL _drag;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // be undecided
    self->_decidedTapOrDrag = NO;
    // prepare for a tap
    NSUInteger ct = [(UITouch*)touches.anyObject tapCount];
    if (ct == 2) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(singleTap)
                                                   object:nil];
        self->_decidedTapOrDrag = YES;
        self->_drag = NO;
        return;
    }
    // prepare for a drag
    self->_decidedDirection = NO;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self->_decidedTapOrDrag && !self->_drag)
        return;
    
    [self.superview bringSubviewToFront:self];
    UITouch* t = touches.anyObject;
    
    self->_decidedTapOrDrag = YES;
    self->_drag = YES;
    if (!self->_decidedDirection) {
        self->_decidedDirection = YES;
        CGPoint then = [t previousLocationInView: self];
        CGPoint now = [t locationInView: self];
        CGFloat deltaX = fabs(then.x - now.x);
        CGFloat deltaY = fabs(then.y - now.y);
        self->_horiz = (deltaX >= deltaY);
    }
    CGPoint loc = [t locationInView: self.superview];
    CGPoint oldP = [t previousLocationInView: self.superview];
    CGFloat deltaX = loc.x - oldP.x;
    CGFloat deltaY = loc.y - oldP.y;
    CGPoint c = self.center;
    if (self->_horiz)
        c.x += deltaX;
    else
        c.y += deltaY;
    self.center = c;
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self->_decidedTapOrDrag || !self->_drag) {
        // end for a tap
        NSUInteger ct = [(UITouch*)touches.anyObject tapCount];
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
