
#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

-(BOOL)respondsToSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"unwind:"]) {
        NSLog(@"%@ is asked if it responds to %@", self, NSStringFromSelector(aSelector));
    }
    BOOL result = [super respondsToSelector:aSelector];
    return result;
}


-(UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    
#define which 2
    
#if which == 1
    
    NSLog(@"%@ returns %@ from vc for unwind segue", self, vc);
    return self.viewControllers[0];
    
#elif which == 2
    NSLog(@"navigation view controller's view controller for unwind is called...");
    UIViewController* vc = [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
    NSLog(@"%@ returns %@ from vc for unwind segue", self, vc);
    return vc;

    
#endif
}

-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    NSLog(@"%@ was asked for segue", self);
    return [UIStoryboardSegue segueWithIdentifier:identifier source:fromViewController destination:toViewController performHandler:^{
        [fromViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [self popToViewController:toViewController animated:YES];
        }];
    }];
}


@end
