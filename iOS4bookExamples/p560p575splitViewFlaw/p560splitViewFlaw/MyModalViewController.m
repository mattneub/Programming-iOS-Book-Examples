

#import "MyModalViewController.h"


@implementation MyModalViewController


- (IBAction)doButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
