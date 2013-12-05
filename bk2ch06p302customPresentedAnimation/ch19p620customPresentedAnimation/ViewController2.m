

#import "ViewController2.h"

@interface ViewController2 () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@end

@implementation ViewController2

-(void)awakeFromNib {
    [super awakeFromNib];
    self.transitioningDelegate = self;
}

- (IBAction)doButton:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return self;

}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

#define which 2
#if which == 1

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* con = [transitionContext containerView];
    UIView* v2 = vc2.view;
    UIView* drop = v2.superview;
    CGRect oldv2frame = v2.frame;
    [con addSubview: v2];
    v2.frame = drop.frame;
    v2.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.4 animations:^{
        v2.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [drop addSubview: v2];
        v2.frame = oldv2frame;
        [transitionContext completeTransition:YES];
    }];
}

#elif which == 2

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* con = [transitionContext containerView];
    UIView* v2 = vc2.view;
    
//    NSLog(@"%@", [con.window performSelector:@selector(recursiveDescription)]);
    
    UIGraphicsBeginImageContextWithOptions(v2.bounds.size, YES, 0);
    [v2.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView* snap = [[UIImageView alloc] initWithImage:im];
    snap.frame = v2.superview.frame;
    snap.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [con addSubview: snap];
    
    [UIView animateWithDuration:0.4 animations:^{
        snap.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        NSLog(@"%@", snap.window); // proving that the extra view is taken down
        
//        double delayInSeconds = 2.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            NSLog(@"%@", [self.view.window performSelector:@selector(recursiveDescription)]);
//        });
    }];
}

#endif



@end
