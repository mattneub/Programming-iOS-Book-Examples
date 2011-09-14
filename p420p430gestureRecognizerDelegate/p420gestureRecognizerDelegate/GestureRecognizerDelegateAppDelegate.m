
#import "GestureRecognizerDelegateAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation GestureRecognizerDelegateAppDelegate

// the user must perform a tap-and-a-half (tap and hold) to “get the view’s attention,” which we will indicate by a pulsing animation on the view; then (and only then) the user can drag the view

@synthesize window=_window;
@synthesize view, longPresser;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIPanGestureRecognizer* p = [[UIPanGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(panning:)];
    UILongPressGestureRecognizer* lp = [[UILongPressGestureRecognizer alloc] 
                                        initWithTarget:self
                                        action:@selector(longPress:)];
    lp.numberOfTapsRequired = 1;
    [view addGestureRecognizer:p];
    [view addGestureRecognizer:lp];
    self.longPresser = lp;
    p.delegate = self;
    [lp release]; [p release];

    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) longPress: (UILongPressGestureRecognizer*) lp {
    if (lp.state == UIGestureRecognizerStateBegan) {
        CABasicAnimation* anim = 
        [CABasicAnimation animationWithKeyPath: @"transform"];
        anim.toValue = 
        [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
        anim.fromValue = 
        [NSValue valueWithCATransform3D:CATransform3DIdentity];
        anim.repeatCount = HUGE_VALF;
        anim.autoreverses = YES;
        [lp.view.layer addAnimation:anim forKey:nil];
    }
    if (lp.state == UIGestureRecognizerStateEnded) {
        [lp.view.layer removeAllAnimations];
    }
}

- (void) panning: (UIPanGestureRecognizer*) p {
    UIView* v = p.view;
    if (p.state == UIGestureRecognizerStateBegan)
        self->origC = v.center;
    CGPoint delta = [p translationInView: v.superview];
    CGPoint c = self->origC;
    c.x += delta.x; c.y += delta.y;
    v.center = c;
}

- (BOOL) gestureRecognizerShouldBegin: (UIGestureRecognizer*) g {
    if (self.longPresser.state == UIGestureRecognizerStatePossible || 
        self.longPresser.state == UIGestureRecognizerStateFailed)
        return NO;
    return YES;
}

- (BOOL)gestureRecognizer: (UIGestureRecognizer*) g1 
shouldRecognizeSimultaneouslyWithGestureRecognizer: (UIGestureRecognizer*) g2 {
    return YES;
}


- (void)dealloc
{
    [_window release];
    [view release];
    [longPresser release];
    [super dealloc];
}

@end
