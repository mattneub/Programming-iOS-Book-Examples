

#import "MyKnob.h"


@implementation MyKnob {
    CGFloat initialAngle;
}
@synthesize angle, continuous;

static CGFloat pToA (UITouch* touch, UIView* self) {
    CGPoint loc = [touch locationInView: self];
    CGPoint c = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return atan2(loc.y - c.y, loc.x - c.x);
} 

- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self->initialAngle = pToA(touch, self);
    return YES;
}

- (BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGFloat ang = pToA(touch, self);
    ang -= self->initialAngle;
    CGFloat absoluteAngle = self->angle + ang;
    if (absoluteAngle < 0) {
        self.transform = CGAffineTransformIdentity;
        self->angle = 0;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        return NO;
    } 
    if (absoluteAngle > 5) {
        self.transform = CGAffineTransformMakeRotation(5);
        self->angle = 5;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        return NO;
    }
    self.transform = CGAffineTransformRotate(self.transform, ang);
    self->angle = absoluteAngle;
    if (self->continuous)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void) drawRect:(CGRect)rect {
    UIImage* knob = [UIImage imageNamed:@"knob.png"];
    [knob drawInRect:rect];
}

- (void) setAngle: (CGFloat) ang {
    if (ang < 0)
        ang = 0;
    if (ang > 5)
        ang = 5;
    self.transform = CGAffineTransformMakeRotation(ang);
    self->angle = ang;
}

@end
