

#import "ViewController.h"
#import "ViewController2.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)doButton:(id)sender {
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Howdy" message:@"This is a test" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    [self presentViewController:[ViewController2 new] animated:YES completion:nil];
}

@end
