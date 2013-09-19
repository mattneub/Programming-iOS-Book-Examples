

#import "RootViewController.h"
#import "SecondViewController.h"

@implementation RootViewController

- (IBAction)doPresent:(id)sender {
    SecondViewController* svc = [SecondViewController new];
// ignore this stuff; just playing, not a good idea as it turns out
//    self.providesPresentationContextTransitionStyle = YES;
//    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    self.definesPresentationContext = YES;
//    svc.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:svc
                       animated:YES completion:nil];
}


@end
