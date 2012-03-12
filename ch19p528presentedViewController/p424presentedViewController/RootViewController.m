

#import "RootViewController.h"
#import "SecondViewController.h"

@implementation RootViewController

- (IBAction)doPresent:(id)sender {
    SecondViewController* svc = [[SecondViewController alloc] init];
//    self.providesPresentationContextTransitionStyle = YES;
//    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    self.definesPresentationContext = YES;
//    svc.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:svc 
                       animated:YES completion:nil];
}


@end
