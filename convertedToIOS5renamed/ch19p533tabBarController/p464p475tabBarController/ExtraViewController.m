

#import "ExtraViewController.h"

@implementation ExtraViewController

- (IBAction)doDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
