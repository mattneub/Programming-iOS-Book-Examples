

#import "RootViewController.h"
#import "MyUnwindSegue.h"


@interface RootViewController ()

@end

@implementation RootViewController

/*
 Example showing how to combine storyboard with non-storyboard view controllers
 to do an unwind segue.
 We have no main storyboard.
 But we do get our next view controllers from a storyboard.
 Then we want to unwind all the way back to here.
 So we implement canPerform and the unwind action here, and it all just happens automatically.
 But see MainViewController for the key trick.
 */

- (IBAction)doButton:(id)sender {
    UIStoryboard* s = [UIStoryboard storyboardWithName:@"SomeStoryboard" bundle:nil];
    UIViewController* vc = [s instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

// this isn't strictly necessary; if we don't say no, the answer is yes

-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    NSLog(@"root view controller can perform, returning YES");
    return YES;
}

-(IBAction) unwind:(UIStoryboardSegue*)segue {
    NSLog(@"RootViewController unwinding %@ %@", segue.identifier, segue.sourceViewController);
}

// this is just so we can make sure the nav stack is being managed correctly for us

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"navigation stack: %@", [self.navigationController viewControllers]);
}



@end
