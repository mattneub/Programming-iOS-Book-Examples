
#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (IBAction)doDismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    // prove that you've got data
    NSLog(@"%@", self.data);
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    if ([self isBeingDismissed])
        [self.delegate acceptData: @"Even more important data!"];
}

@end
