
#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

// this is the key trick
// this is NOT where want to unwind to
// but we need an unwind action somewhere in the storyboard...
// or else we can't create the unwind segue in IB!
// so we have the unwind action here...
// and then we also have code that says "NO, keep searching up the parent chain"

-(IBAction) unwind:(UIStoryboardSegue*)segue {
    // THIS SHOULD NEVER BE CALLED
    NSLog(@"MainViewController unwinding %@", segue.sourceViewController);
}

-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    NSLog(@"main view controller can perform, returning NO");
    return NO;
}

// just to prove that the nav stack is being correctly populated

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"navigation stack: %@", [self.navigationController viewControllers]);
}

-(void)dealloc {
    NSLog(@"dealloc mainviewcontroller");
}



@end
