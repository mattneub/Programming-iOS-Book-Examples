

#import "ViewController.h"

@implementation ViewController

- (IBAction) buttonPressed: (id) sender {
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Howdy!"
                                                 message:@"You tapped me." 
                                                delegate:nil 
                                       cancelButtonTitle:@"Cool"
                                       otherButtonTitles:nil];
    [av show];
}


@end
