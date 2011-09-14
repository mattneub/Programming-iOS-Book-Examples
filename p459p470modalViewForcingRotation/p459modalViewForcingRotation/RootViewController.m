
#import "RootViewController.h"
#import "LandscapeViewController.h"

@implementation RootViewController


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    // Return YES for supported orientations
    // return UIInterfaceOrientationIsPortrait(io);
    return io == UIInterfaceOrientationPortrait;
}

- (IBAction)doRotate:(id)sender {
    LandscapeViewController* lvc = [[LandscapeViewController alloc] init];
    [self presentModalViewController:lvc animated:NO]; // try also YES
    [lvc release];
}



@end
