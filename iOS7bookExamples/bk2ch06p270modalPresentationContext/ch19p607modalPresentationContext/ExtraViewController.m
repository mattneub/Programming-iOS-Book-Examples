

#import "ExtraViewController.h"

@interface ExtraViewController ()

@end

@implementation ExtraViewController

- (IBAction)doButton:(id)sender {
    NSLog(@"presented vc's presenting vc: %@", self.presentingViewController);
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
