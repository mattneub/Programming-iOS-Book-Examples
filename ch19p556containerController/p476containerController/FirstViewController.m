
#import "FirstViewController.h"

@implementation FirstViewController

- (void) willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"%@ will", self);
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"%@ did", self);
}


@end
