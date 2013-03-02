

#import "PresentedViewController.h"

@implementation PresentedViewController

// does nothing and is never called
// it's just here so we can create the unwind segue in IB at all

- (IBAction) unwind: (UIStoryboardSegue*) segue {
    NSLog(@"this code never runs");
}

// this is how we prevent this unwind: from ever being called

-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return NO;
}

@end
