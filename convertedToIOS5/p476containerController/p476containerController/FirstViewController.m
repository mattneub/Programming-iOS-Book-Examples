
#import "FirstViewController.h"

@implementation FirstViewController

- (void) willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"%@ will", self);
}

- (void) didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"%@ did", self);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
