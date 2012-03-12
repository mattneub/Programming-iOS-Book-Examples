
#import "LandscapeViewController.h"


@implementation LandscapeViewController



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    // Return YES for supported orientations
    // return UIInterfaceOrientationIsLandscape(io);
    return io == UIInterfaceOrientationLandscapeRight;
}

- (IBAction)doRotate:(id)sender {
    // note that on iOS "parent" no longer means "modal presenter"; it is nil
    // the presenter is the presentingViewController
    // we should not really think of modal views as modal any more;
    // it's just a matter of view-swapping
    
    // [self dismissModalViewControllerAnimated:NO]; // percolates up to parent; try also YES
    // the above is legal in iOS 5, but there is a new more generalized way to present modally
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:NO completion:nil];
    // this percolates up so that the correct view controller is dismissed
    // however, as the book explains, in the more general case...
    // you may want a way to speak directly to the presenter
    // if that isn't the presentingViewController you can use a delegate or notification architecture
    
    // change NO to YES and you will get an interesting surprise (new feature in iOS 5)
    // we define the modal transition style as a dissolve
    // however, our presenter contains these lines:
    //     self.definesPresentationContext = YES;
    //     self.providesPresentationContextTransitionStyle = YES;
    // this means that its own modal transition style overrides!
    // since it also says self.modalTransitionStyle = UIModalTransitionStyleCoverVertical,
    // that's the style that is used
    
}

@end
