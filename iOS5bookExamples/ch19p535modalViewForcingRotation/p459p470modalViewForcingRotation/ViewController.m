
#import "ViewController.h"
#import "LandscapeViewController.h"

@implementation ViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    // Return YES for supported orientations
    // return UIInterfaceOrientationIsPortrait(io);
    return io == UIInterfaceOrientationPortrait;
}

- (IBAction)doRotate:(id)sender {
    LandscapeViewController* lvc = [[LandscapeViewController alloc] init];
    // [self presentModalViewController:lvc animated:NO]; // try also YES
    // the above is legal in iOS 5, but there is a new more generalized way to present modally
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.definesPresentationContext = YES;
    self.providesPresentationContextTransitionStyle = YES;
    // the above can also be set in nib or storyboard
    [self presentViewController:lvc animated:NO completion:nil];
 }


@end
