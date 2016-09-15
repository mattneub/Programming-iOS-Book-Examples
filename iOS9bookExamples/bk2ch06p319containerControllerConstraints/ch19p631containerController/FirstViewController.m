
#import "FirstViewController.h"

@implementation FirstViewController

- (void) willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"%@ willMove", self);
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"%@ didMove", self);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@ willAppear", self);
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@ didAppear", self);
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@ willDisappear", self);
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@ didDisappear", self);
}


@end
