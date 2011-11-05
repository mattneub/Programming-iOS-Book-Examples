

#import "ViewController.h"
#import "PanelViewController.h"
#import "FlipViewController.h"

@implementation ViewController {
    int cur;
}
@synthesize panel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    PanelViewController* pvc = [[PanelViewController alloc] init];
    [self addChildViewController:pvc];
    pvc.view.frame = self.panel.bounds;
    [self.panel addSubview: pvc.view];
    [pvc didMoveToParentViewController:self];
    // willMove is sent automatically by add, but we must send didMove
    
    FlipViewController* flip = [[FlipViewController alloc] init];
    [self addChildViewController: flip];
    [flip didMoveToParentViewController:self];
    // willMove is sent automatically by add, but we must send didMove

}

- (IBAction)doFlip:(id)sender {
    UIViewController* fromvc = [self.childViewControllers objectAtIndex:cur];
    cur = (cur == 0) ? 1 : 0;
    UIViewController* tovc = [self.childViewControllers objectAtIndex:cur];
    tovc.view.frame = self.panel.bounds;

    // note: if you call transition, do not call willMove, but do call didMove in the completion
    [self transitionFromViewController:fromvc
                      toViewController:tovc
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:nil
                            completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
