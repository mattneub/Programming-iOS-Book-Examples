

#import "AppDelegate.h"

@interface AppDelegate () <UITabBarControllerDelegate, UIViewControllerAnimatedTransitioning, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition* inter;
@property BOOL interacting;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer* rightEdger;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer* leftEdger;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UITabBarController* tbc = (UITabBarController*)self.window.rootViewController;
    tbc.delegate = self;
    
    UIScreenEdgePanGestureRecognizer* sep = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    sep.edges = UIRectEdgeRight;
    [tbc.view addGestureRecognizer:sep];
    sep.delegate = self;
    self.rightEdger = sep;
    
    sep = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    sep.edges = UIRectEdgeLeft;
    [tbc.view addGestureRecognizer:sep];
    sep.delegate = self;
    self.leftEdger = sep;

    return YES;
}

-(BOOL)gestureRecognizerShouldBegin:(UIScreenEdgePanGestureRecognizer *)g {
    UITabBarController* tbc = (UITabBarController*)self.window.rootViewController;
    BOOL result = NO;
    if (g == self.rightEdger)
        result = (tbc.selectedIndex < tbc.viewControllers.count - 1);
    else
        result = (tbc.selectedIndex > 0);
    return result;
}

- (void) pan: (UIScreenEdgePanGestureRecognizer *) g {
    UIView* v = g.view;
    if (g.state == UIGestureRecognizerStateBegan) {
        NSLog(@"%@", @"begin");
        self.inter = [UIPercentDrivenInteractiveTransition new];
        self.interacting = YES;
        UITabBarController* tbc = (UITabBarController*)self.window.rootViewController;
        if (g == self.rightEdger)
            tbc.selectedIndex = tbc.selectedIndex + 1;
        else
            tbc.selectedIndex = tbc.selectedIndex - 1;
    }
    else if (g.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [g translationInView: v];
        CGFloat percent = fabs(delta.x/v.bounds.size.width);
        [self.inter updateInteractiveTransition:percent];
        
    }
    else if (g.state == UIGestureRecognizerStateEnded) {
        CGPoint delta = [g translationInView: v];
        CGFloat percent = fabs(delta.x/v.bounds.size.width);
        self.inter.completionSpeed = 0.5;
        // (try completionSpeed = 2 to see "ghosting" problem after a partial)
        // (can occur with 1 as well)
        // (setting to 0.5 seems to fix it)
        
        if (percent > 0.5) {
            NSLog(@"%@", @"calling finish");
            [self.inter finishInteractiveTransition];
        }
        else {
            NSLog(@"%@", @"calling cancel");
            [self.inter cancelInteractiveTransition];
        }
    }
    else if (g.state == UIGestureRecognizerStateCancelled) {
        [self.inter cancelInteractiveTransition];
    }
}

-(id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return self;
}

-(id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interacting ? self.inter : nil; // no interaction if we didn't use g.r.
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* vc1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* con = [transitionContext containerView];
    CGRect r1start = [transitionContext initialFrameForViewController:vc1];
    CGRect r2end = [transitionContext finalFrameForViewController:vc2];
    UIView* v1 = vc1.view;
    UIView* v2 = vc2.view;
    
    // which way we are going depends on which vc is which
    // the most general way to express this is in terms of index number
    UITabBarController* tbc = (UITabBarController*)self.window.rootViewController;
    NSUInteger ix1 = [tbc.viewControllers indexOfObject:vc1];
    NSUInteger ix2 = [tbc.viewControllers indexOfObject:vc2];
    int dir = ix1 < ix2 ? 1 : -1;
    CGRect r = r1start;
    r.origin.x -= r.size.width * dir;
    CGRect r1end = r;
    r = r2end;
    r.origin.x += r.size.width * dir;
    CGRect r2start = r;
    
    v2.frame = r2start;
    [con addSubview:v2];
    // interaction looks much better if animation curve is linear
    UIViewAnimationOptions opts = 0;
    if (self.interacting)
        opts = UIViewAnimationOptionCurveLinear;
    
    /*
    if (self.interacting) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            UIView* v = v2;
            while (![v isKindOfClass:[UIWindow class]]) {
                if (v.layer.speed < 0.1)
                    NSLog(@"%@ %f", v, v.layer.timeOffset); // :)))) gotcha
                v = v.superview;
            }
        });
    }
     */
    
    [UIView animateWithDuration:0.4 delay:0 options:opts animations:^{
        v1.frame = r1end;
        v2.frame = r2end;
    } completion:^(BOOL finished) {
        // this turns out to be an even better workaround to the black screen problem
        double delayInSeconds = 0.1;
        dispatch_time_t popTime =
            dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            BOOL cancelled = [transitionContext transitionWasCancelled];
            NSLog(@"calling complete transition %d", !cancelled);
            [transitionContext completeTransition:!cancelled];
        });
        self.interacting = NO;
    }];
}

// also notice logging during cancellation
// proves that viewWill... can occur without viewDid...
// and that it can occur multiple times


@end
