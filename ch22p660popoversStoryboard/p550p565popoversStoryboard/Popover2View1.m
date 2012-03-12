
#import "Popover2View1.h"

@implementation Popover2View1

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIButton* b = (UIButton*)[[(UIViewController*)segue.destinationViewController view] 
                              viewWithTag:1];
    [b addTarget:sender action:@selector(done:) forControlEvents:UIControlEventTouchUpInside]; 
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
