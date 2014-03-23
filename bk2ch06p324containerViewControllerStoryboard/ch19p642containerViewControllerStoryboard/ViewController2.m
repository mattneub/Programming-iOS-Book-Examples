

#import "ViewController2.h"

@interface ViewController2 () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@end

@implementation ViewController2

-(void)awakeFromNib {
    [super awakeFromNib];
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
}
- (IBAction)doButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // UIViewController* vc1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* con = [transitionContext containerView];
    // CGRect r1start = [transitionContext initialFrameForViewController:vc1];
    CGRect r2end = [transitionContext finalFrameForViewController:vc2];
    // UIView* v1 = vc1.view;
    UIView* v2 = vc2.view;

    CGRect r2start = r2end;
    r2start.origin.y -= r2start.size.height;
    v2.frame = r2start;
    [con addSubview:v2];
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:20 options:0 animations:^{
        v2.frame = r2end;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
}


@end
