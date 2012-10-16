
#import "ViewController.h"
#import "LandscapeViewController.h"

@implementation ViewController

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)doRotate:(id)sender {
    LandscapeViewController* lvc = [[LandscapeViewController alloc] init];
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.definesPresentationContext = YES;
    self.providesPresentationContextTransitionStyle = YES;
    // the above can also be set in nib or storyboard
    [self presentViewController:lvc animated:NO completion:nil];
 }


@end
