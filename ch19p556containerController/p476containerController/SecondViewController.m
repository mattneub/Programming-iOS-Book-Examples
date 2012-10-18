

#import "SecondViewController.h"

@implementation SecondViewController

- (void) willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"%@ will", self);
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"%@ did", self);
}


@end
