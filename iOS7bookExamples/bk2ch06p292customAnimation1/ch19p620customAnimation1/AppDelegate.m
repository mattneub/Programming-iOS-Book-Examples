

#import "AppDelegate.h"

@interface AppDelegate () <UITabBarControllerDelegate, UIViewControllerAnimatedTransitioning>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UITabBarController* tbc = (UITabBarController*)self.window.rootViewController;
    tbc.delegate = self;
    
    return YES;
}

-(id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
//    NSLog(@"%@", [self.window performSelector:@selector(recursiveDescription)]);

    
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* vc1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* con = [transitionContext containerView];
    
    
//    NSLog(@"%@", [con performSelector:@selector(recursiveDescription)]);
    
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
    
//    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,100)];
//    v.backgroundColor = [UIColor blackColor];
//    [con addSubview:v];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.4 animations:^{
        v1.frame = r1end;
        v2.frame = r2end;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

							

@end
