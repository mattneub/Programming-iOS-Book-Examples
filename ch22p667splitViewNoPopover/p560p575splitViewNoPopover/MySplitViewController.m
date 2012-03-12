
/*
 Since I've already argued that UISplitViewController's popover-based approach sucks,
 and since we are now allowed to make our own container view controllers,
 it seems obviously incumbent on me to sketch an alternative.
 
 Here's one that imitates the iOS 5 version of Apple Mail on the iPad.
 I haven't implemented the swipe gestures, but it should be obvious how one might add that.
 Tap "Master" to summon the master view if it isn't showing,
 tap elsewhere to hide the master view if it's overlapping the Detail view.
 
 The hard part was realizing what the secret was of taking a view controller and 
 drawing its view with rounded corners and a possible shadow, without modifying that view.
 The secret: embed it in another view! Took me a while to think of that...
 because before we could do our own container view controllers it wasn't strictly legal
 
 */

#import "MySplitViewController.h"
#import "ShadowView.h"
#import "RounderView.h"
#import <QuartzCore/QuartzCore.h>

@interface MySplitViewController()
@property (nonatomic, assign) UIViewController* vc1;
@property (nonatomic, assign) UIViewController* vc2;
@end

@implementation MySplitViewController
@synthesize viewControllers=_viewControllers;
@synthesize vc1, vc2;

- (BOOL) automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
    return YES;
}

- (void) setViewControllers: (NSArray*) vcs {
    if (![vcs count] == 2)
        [NSException raise:@"IncorrectParams" format:@"Must supply exactly two view controllers."];
    [vcs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[UIViewController class]])
            [NSException raise:@"IncorrectPararms" format: @"Must supply view controllers."];
    }];
    if (vcs != self.viewControllers) {
        self->_viewControllers = [vcs copy];
        self.vc1 = [self->_viewControllers objectAtIndex:0];
        [self addChildViewController:self.vc1];
        [self.vc1 didMoveToParentViewController:self];
        self.vc2 = [self->_viewControllers objectAtIndex:1];
        [self addChildViewController:self.vc2];
        [self.vc2 didMoveToParentViewController:self];
    }
}

- (void)loadView
{
    UIView* v = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
    self.view = v;
    v.backgroundColor = [UIColor blackColor];
    UIView* v1 = self.vc1.view;
    UIView* v2 = self.vc2.view;
    CGRect frame1 = CGRectMake(-320, 0, 320, self.view.bounds.size.height);
    CGRect frame2 = self.view.bounds;

    
    // first view is a view that casts a shadow
    ShadowView* shadow1 = [[ShadowView alloc] initWithFrame:frame1];
    shadow1.tag = 1;
    // in it, embed a view that rounds its corners
    RounderView* rounder1 = [[RounderView alloc] initWithFrame: shadow1.bounds];
    rounder1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [shadow1 addSubview: rounder1];
    // in it, embed the first view we were handed
    v1.frame = rounder1.bounds;
    v1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [rounder1 addSubview: v1];

    // second view is a view that rounds its corners
    RounderView* rounder2 = [[RounderView alloc] initWithFrame: frame2];
    rounder2.tag = 2;
    // in it, embed the second view we were handed
    v2.frame = rounder2.bounds;
    v2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [rounder2 addSubview: v2];

    // stick them in our view!
    [v addSubview: shadow1];
    [v addSubview: rounder2];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)io duration:(NSTimeInterval)d 
{
    [UIView animateWithDuration:d animations:^{
        if (UIInterfaceOrientationIsPortrait(io)) {
            [self.view viewWithTag: 1].frame = CGRectMake(-320,0,320,self.view.bounds.size.height);
            [self.view viewWithTag: 2].frame = self.view.bounds;
        } else {
            CGRect frame1;
            CGRect frame2;
            CGRectDivide(self.view.bounds, &frame1, &frame2, 320, CGRectMinXEdge);
            [self.view viewWithTag: 1].frame = frame1;
            [self.view viewWithTag: 2].frame = frame2;
        }
    } completion:^(BOOL b) {
            ((ShadowView*)[self.view viewWithTag: 1]).showsShadow = NO;
    }];
}

- (void) showView1 {
    ShadowView* v = (ShadowView*)[self.view viewWithTag:1];
    [self.view bringSubviewToFront:v];
    v.showsShadow = YES;
    // insert modal-enforcing tap-detecting invisible view
    UIView* v2 = [[UIView alloc] initWithFrame:self.view.bounds];
    v2.tag = 3;
    UITapGestureRecognizer* t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView1:)];
    [v2 addGestureRecognizer:t];
    [self.view insertSubview:v2 belowSubview:v];
    [UIView animateWithDuration:.2 animations:^{
        v.frame = CGRectMake(0,0,320,self.view.bounds.size.height);
    }];
}

- (void) hideView1: (UIGestureRecognizer*) g {
    [g.view removeFromSuperview]; // thank you very much
    ShadowView* v = (ShadowView*)[self.view viewWithTag:1];
    [UIView animateWithDuration:.2 animations:^{
        v.frame = CGRectMake(-320,0,320,self.view.bounds.size.height);
    } completion:^(BOOL finished) {
        v.showsShadow = NO;
    }];
}

@end
