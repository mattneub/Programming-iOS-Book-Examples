

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(IBAction)unwind: (UIStoryboardSegue*) seg {
    NSLog(@"%@", @"root view controller unwind is called");
}

-(BOOL)respondsToSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"unwind:"]) {
        NSLog(@"%@ is asked if it responds to %@", self, NSStringFromSelector(aSelector));
    }
    BOOL result = [super respondsToSelector:aSelector];
    return result;
}

-(UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    UIViewController* vc = [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
    NSLog(@"%@ returns %@ from vc for unwind segue", self, vc);
    return vc;
}

-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    NSLog(@"%@ was asked for segue", self);
    return nil;
}



@end
