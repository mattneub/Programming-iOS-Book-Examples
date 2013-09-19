

#import "AppDelegate.h"

@interface AppDelegate () <UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [(UINavigationController*)self.window.rootViewController setDelegate:self];
    return YES;
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush)
        return self;
    return nil;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
//    UIViewController* vc1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* con = [transitionContext containerView];
    
//    NSLog(@"%@", [con performSelector:@selector(recursiveDescription)]);

    
    
//    CGRect r1start = [transitionContext initialFrameForViewController:vc1];
    CGRect r2end = [transitionContext finalFrameForViewController:vc2];
//    UIView* v1 = vc1.view;
    UIView* v2 = vc2.view;
    [con addSubview: v2];
    v2.frame = r2end;
    v2.alpha = 0;
    
    [UIView animateWithDuration:0.6 animations:^{
        v2.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
}

							

@end
