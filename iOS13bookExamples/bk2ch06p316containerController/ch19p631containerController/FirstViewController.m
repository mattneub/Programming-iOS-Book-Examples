
#import "FirstViewController.h"

@implementation FirstViewController

- (void) willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"%@ willMove", self);
    NSLog(@"%@", self.transitionCoordinator); // just proving we don't magically get t.c.
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"%@ didMove", self);
    NSLog(@"%@", self.transitionCoordinator);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@ willAppear", self);
    NSLog(@"%@", self.transitionCoordinator);
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@ didAppear", self);
    NSLog(@"%@", self.transitionCoordinator);
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@ willDisappear", self);
    NSLog(@"%@", self.transitionCoordinator);
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@ didDisappear", self);
    NSLog(@"%@", self.transitionCoordinator);
}


@end
