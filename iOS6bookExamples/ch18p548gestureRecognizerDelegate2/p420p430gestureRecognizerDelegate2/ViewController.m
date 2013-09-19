
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

// the user must perform a tap-and-a-half (tap and hold) to “get the view’s attention,” which we will indicate by a pulsing animation on the view; then (and only then) the user can drag the view

// the implementation using two gesture recognizers is actually unnecessary to do this,
// because the long press gesture recognizer is also a pan gesture recognizer
// so for the sake of completeness here's the example again without the delegate
// and without the second gesture recognizer

@interface ViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) IBOutlet UIView* v;
@end

@implementation ViewController

{
    CGPoint _origOffset;
}

- (void)viewDidLoad
{

    UILongPressGestureRecognizer* lp = [[UILongPressGestureRecognizer alloc] 
                                        initWithTarget:self
                                        action:@selector(longPress:)];
    lp.numberOfTapsRequired = 1;
    [self.v addGestureRecognizer:lp];

}

- (void) longPress: (UILongPressGestureRecognizer*) lp {
    UIView* vv = lp.view;
    if (lp.state == UIGestureRecognizerStateBegan) {
        CABasicAnimation* anim = 
        [CABasicAnimation animationWithKeyPath: @"transform"];
        anim.toValue = 
        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
        anim.fromValue = 
        [NSValue valueWithCATransform3D:CATransform3DIdentity];
        anim.repeatCount = HUGE_VALF;
        anim.autoreverses = YES;
        [vv.layer addAnimation:anim forKey:nil];
        // oddly, UILongPressGestureRecognizer lacks translationInView:,
        // so we have to keep track of the whole movement ourselves
        self->_origOffset = CGPointMake(CGRectGetMidX(vv.bounds) - [lp locationInView:vv].x,
                                       CGRectGetMidY(vv.bounds) - [lp locationInView:vv].y);
    }
    if (lp.state == UIGestureRecognizerStateChanged) {
        CGPoint c = [lp locationInView: vv.superview];
        c.x += self->_origOffset.x;
        c.y += self->_origOffset.y;
        vv.center = c;
    }
    if (lp.state == UIGestureRecognizerStateEnded ||
        lp.state == UIGestureRecognizerStateCancelled) {
        [vv.layer removeAllAnimations];
    }
}




@end
