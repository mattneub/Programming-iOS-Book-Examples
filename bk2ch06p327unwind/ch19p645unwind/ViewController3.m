
#import "ViewController3.h"

@interface ViewController3 ()

@end

@implementation ViewController3

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


-(IBAction)unwind: (UIStoryboardSegue*) seg {
    NSLog(@"%@", @"view controller 3 unwind is never called");
}

-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    NSLog(@"%@", @"view controller 3 can perform is never called");
    return NO;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSLog(@"%@", @"view controller 3 should perform returns YES");
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", @"view controller 3 prepare for segue is called");
}


@end
