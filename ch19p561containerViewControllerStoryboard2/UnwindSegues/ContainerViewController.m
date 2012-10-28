
#import "ContainerViewController.h"
#import "UnwindSegue.h"

@implementation ContainerViewController

- (void) flipWithSegue: (UIStoryboardSegue*) segue fromLeft:(BOOL)fromLeft {
    UIViewAnimationOptions transition = 
    fromLeft ?
    UIViewAnimationOptionTransitionFlipFromLeft :
    UIViewAnimationOptionTransitionFlipFromRight;
    
    UIViewController* fromvc = segue.sourceViewController;
    UIViewController* tovc = segue.destinationViewController;
    tovc.view.frame = fromvc.view.frame;
    [self addChildViewController:tovc];
    [fromvc willMoveToParentViewController:nil];
    [self transitionFromViewController:fromvc
                      toViewController:tovc
                              duration:0.4
                               options: transition
                            animations:nil
                            completion:^(BOOL done){
                                [tovc didMoveToParentViewController:self];
                                [fromvc removeFromParentViewController];
                                // just to prove that everything came out all right
                                NSLog(@"%@", self.childViewControllers);
                            }];
}

// ====== present

// message from our segue's perform

- (void) doPresent: (UIStoryboardSegue*) segue {
    [self flipWithSegue: segue fromLeft:YES];
}

// ======= unwind

// set up target (must be our child and must implement unwind)

-(UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    UIViewController* uscvc = [self.storyboard instantiateViewControllerWithIdentifier:@"containedViewController"];
    [self addChildViewController:uscvc];
    return uscvc;
}

// optional but fun: substitute a different segue

-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    return [[UnwindSegue alloc] initWithIdentifier:@"customUnwind" source:fromViewController destination:toViewController];
}

// message from our segue's perform

- (void)performUnwind:(UIStoryboardSegue*)segue {
    [self flipWithSegue:segue fromLeft:NO];
}


@end
