

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

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


-(IBAction)unwind: (UIStoryboardSegue*) seg {
    NSLog(@"%@", @"view controller 2 unwind is called");
}

-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    
#define which 2
    
#if which == 1
    
    NSLog(@"%@", @"view controller 2 can perform returns YES");
    return YES;
    
#elif which == 2
    
    NSLog(@"%@", @"view controller 2 can perform returns NO");
    return NO;

#endif
}

-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    NSLog(@"%@ was asked for segue", self);
    return nil;
}


@end
