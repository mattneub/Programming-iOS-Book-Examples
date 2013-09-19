
#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

// note that we are no longer a delegate implementing a protocol


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        NSLog(@"preparing %@", segue.destinationViewController);
        // if we need to send data to the FlipsideViewController,
        // we can get it as segue.destinationViewController
        FlipsideViewController* flip = segue.destinationViewController;
        flip.inputString = @"I am cool";
    }
}


/*
 This is what's new. Once this is present here in MainViewController - 
 it must be an IBAction and it must take a segue as its parameter -
 the Exit object in FlipsideViewController comes to life!
 The dismiss button in FlipsideViewController can then be connected to the Exit object
 and from there all the way up to this method here in MainViewController,
 in a single move!
 */

-(IBAction) unwind:(UIStoryboardSegue*)segue {
    NSLog(@"unwinding %@", segue.sourceViewController);
    // the unwinding will take place automatically!
    // if we need to get data from the FlipsideViewController,
    // we can get it as segue.sourceViewController
    // (this is a different segue, and runs back to us)
    // moreover, if need be, the segue can have in identifier
    if ([segue.identifier isEqualToString:@"returnFromAlternate"]) {
        FlipsideViewController* flip = segue.sourceViewController;
        NSLog(@"obtaining output from presented controller: %@", flip.outputString);
    }
}

@end
