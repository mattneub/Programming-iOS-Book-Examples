

#import "RootViewController.h"
// #import "FirstViewController.h"
// #import "SecondViewController.h"

@interface RootViewController ()
@end

@implementation RootViewController

// note that there is now no "swappers" array and no "cur" ivar
// keeping track of which view controller we are moving from and to...
// will be done for us merely by their presence (connected by segues) in the storyboard!



// this next method isn't needed; I'm just using to log...
// to prove that the installation of the child view controller
// really is performed as a segue
// we can capture the segue info, but the FirstViewController is not yet our child...

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedFirstViewController"]) {
        NSLog(@"from %@", segue.sourceViewController);
        NSLog(@"to %@", segue.destinationViewController);
        NSLog(@"children %@", self.childViewControllers);
    }
}

// ... but then by the time we get viewDidLoad,
// the FirstViewController is our child! and the view is in the right place,
// no code needed!

-(void)viewDidLoad {
    [super viewDidLoad];
    // logging and view classes prove that the embedded view goes inside the container view
    // and that this has already happened at this point
    NSLog(@"viewdidload children %@", self.childViewControllers);
    NSLog(@"%@", self.view);
    NSLog(@"%@", self.view.subviews);
    UIView* v = [self.view viewWithTag:100];
    do
    {
        NSLog(@"%@", v);
        v = v.superview;
    }
    while (v);
    

}

// and now doFlip starts the segue from our current child
// we don't know what class our current child is and we don't care

- (IBAction)doFlip:(id)sender {
    [self.childViewControllers[0] performSegueWithIdentifier:@"flip" sender:self];
}

// we have cleverly passed a reference to ourself down the chain to the segue
// and the segue now calls us back to perform the segue
// this is *exactly* like what we were previously doing in doFlip!
// the only difference is that the segue tells us the source and destination

- (void) doTransition:(UIStoryboardSegue*)segue {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    // the segue tells us the from and to
    // the from is already our child
    UIViewController* fromvc = segue.sourceViewController;
    UIViewController* tovc = segue.destinationViewController;
    tovc.view.frame = fromvc.view.frame;
    
    [self addChildViewController:tovc]; // "will" called for us
    // note: when we call remove, we must call "will" (with nil) beforehand
    [fromvc willMoveToParentViewController:nil];
    // then perform the transition
    [self transitionFromViewController:fromvc
                      toViewController:tovc
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:nil
                            completion:^(BOOL done){
                                // finally, finish up
                                // note: when we call add, we must call "did" afterwards
                                [tovc didMoveToParentViewController:self];
                                [fromvc removeFromParentViewController]; // "did" called for us
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                NSLog(@"postflip children %@", self.childViewControllers);
                            }];
}

// NOTE: the simplicity of the above depends on the fact that we are allowed to have
// two segues with the same identifier in the same storyboard

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@", @"will appear");
    return;
    UIView* v = [self.view viewWithTag:100];
    do
    {
        NSLog(@"%@", v);
        v = v.superview;
    }
    while (v);
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"%@", @"did appear");
    return;
    UIView* v = [self.view viewWithTag:100];
    do
    {
        NSLog(@"%@", v);
        v = v.superview;
    }
    while (v);
}

@end
