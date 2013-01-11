

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController
- (IBAction)doButton:(id)sender {
    UIStoryboard* s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController* vc = [s instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:nil];
}

// so the question is: can an unwind find its way all the way back to here?
// you bet your booties

-(IBAction)unwind:(UIStoryboardSegue*)seg {
    NSLog(@"root %@", @"unwind");
}


@end
