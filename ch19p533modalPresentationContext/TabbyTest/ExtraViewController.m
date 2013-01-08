

#import "ExtraViewController.h"

@interface ExtraViewController ()

@end

@implementation ExtraViewController

-(NSUInteger)supportedInterfaceOrientations {
    // if we're presented in UIModalPresentationCurrentContext, this is a Bad Idea
    NSLog(@"%@", @"here");
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    // even weirder, this fixes the problem, even though it isn't called!
    NSLog(@"%@", @"here2");
    return UIInterfaceOrientationPortrait;
}

- (IBAction)doButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
