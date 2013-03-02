

#import "MyNavigationController.h"
#import "MyAmazingSegue.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

-(UIViewController *)viewControllerForUnwindSegueActionNOT:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    NSLog(@"%@", @"nav controller providing");
    return [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
}

-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)tvc
                                     fromViewController:(UIViewController *)fvc
                                             identifier:(NSString *)ident {
    if ([ident isEqualToString:@"farUnwind"]) {
        NSLog(@"%@", @"segue substitution");
        return [[MyAmazingSegue alloc] initWithIdentifier:@"amazing"
                                                   source:fvc
                                              destination:self.viewControllers[0]];
    }
    // otherwise, do not interfere
    return [super segueForUnwindingToViewController:tvc fromViewController:fvc identifier:ident];
}

@end
