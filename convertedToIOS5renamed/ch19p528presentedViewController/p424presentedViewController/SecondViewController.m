
#import "SecondViewController.h"

@implementation SecondViewController
- (IBAction)doDismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}


@end
