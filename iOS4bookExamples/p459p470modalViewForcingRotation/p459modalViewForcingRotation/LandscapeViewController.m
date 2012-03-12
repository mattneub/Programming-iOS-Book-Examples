
#import "LandscapeViewController.h"


@implementation LandscapeViewController



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    // Return YES for supported orientations
    // return UIInterfaceOrientationIsLandscape(io);
    return io == UIInterfaceOrientationLandscapeRight;
}

- (IBAction)doRotate:(id)sender {
    [self dismissModalViewControllerAnimated:NO]; // percolates up to parent; try also YES
}

@end
