

#import "MyNavigationController.h"
#import "MyUnwindSegue.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController


/*
 
 This is rather artificial, but it does show clearly what these methods do.
 
 First, leave the two chunks of code here commented out, and run the example.
 Make sure you understand from the logging how it works:
 the runtime searches for a segue destination by walking up the v.c. chain
 until it finds someone who says YES to canPerformUnwindSegueAction:
 (or at least has the appropriate action method and doesn't say NO).
 
 Second, uncomment the first chunk of code below and run the example.
 The result appears to be the same, but look at the logging and you'll see
 that what we've done is to change the way the segue destination is found.
 The second controller up the chain (RootViewController) is contained,
 so *before* we consult his canPerformUnwindSegueAction:,
 we consult his *container* to see if the container implements viewControllerForUnwindSegueAction.
 In this case, the container (this navigation controller) *does* implement it,
 so we take the parent's word and we never call the child's canPerformUnwind at all.
 
 */

/*
-(UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    NSLog(@"nav controller designating Root View Controller as target of segue");
    return self.viewControllers[0];
}
 */

/*
 Third, uncomment the chunk of code below and run the example.
 This shows the power of the container of the destination controller
 (found in either of the two ways I've just discussed)
 to substitute dynamically a different segue class.
 */

/*
-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    NSLog(@"nav controller substituting custom segue class, received to %@ from %@, id %@", toViewController, fromViewController, identifier);
    return [[MyUnwindSegue alloc] initWithIdentifier:@"customUnwinder" source:fromViewController destination:toViewController];
}

-(void) unwindThisPuppy: (UIStoryboardSegue*) segue {
    // called by our custom segue class's perform
    NSLog(@"nav controller performing custom segue behavior");
    [(UIViewController*)segue.sourceViewController dismissViewControllerAnimated:YES completion:^{
        [self popToRootViewControllerAnimated:YES];
    }];
}
 */


@end
