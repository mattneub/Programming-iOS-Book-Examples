

#import "ViewController2.h"

@interface ViewController2 () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController2

-(id)initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle {
    self = [super initWithNibName:nib bundle:bundle];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}

- (IBAction)doButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.borderColor = self.view.tintColor.CGColor;
    self.view.layer.borderWidth = 2;
    self.view.layer.cornerRadius = 10;
    self.view.layer.masksToBounds = YES;
    self.button.layer.borderColor = self.button.tintColor.CGColor;
    self.button.layer.borderWidth = 1;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(10,10), NO, 0);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor colorWithWhite:0.4 alpha:1.5].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,10,10));
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.button setBackgroundImage:im forState:UIControlStateHighlighted];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* vc1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* con = [transitionContext containerView];
    UIView* v1 = vc1.view;
    UIView* v2 = vc2.view;
    if (v2 == self.view) {
        UIView* shadow = [[UIView alloc] initWithFrame:con.bounds];
        shadow.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.2];
        shadow.alpha = 0;
        shadow.tag = 987;
        [con addSubview: shadow];
        v2.center = CGPointMake(CGRectGetMidX(con.bounds), CGRectGetMidY(con.bounds));
        v2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        CGAffineTransform scale = CGAffineTransformMakeScale(1.6,1.6);
        v2.transform = CGAffineTransformConcat(scale, v2.transform);
        v2.alpha = 0;
        [con addSubview: v2];
        v1.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [UIView animateWithDuration:0.25 animations:^{
            v2.alpha = 1;
            v2.transform = CGAffineTransformConcat(CGAffineTransformInvert(scale), v2.transform);
            shadow.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        UIView* shadow = [con viewWithTag:987];
        [UIView animateWithDuration:0.25 animations:^{
            shadow.alpha = 0;
            v1.transform = CGAffineTransformScale(v1.transform,0.5,0.5);
            v1.alpha = 0;
        } completion:^(BOOL finished) {
            v2.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            [transitionContext completeTransition:YES];
        }];
    }
}




@end
