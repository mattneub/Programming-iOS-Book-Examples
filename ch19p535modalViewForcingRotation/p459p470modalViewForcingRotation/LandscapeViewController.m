
#import "LandscapeViewController.h"


@implementation LandscapeViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)doRotate:(id)sender {
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
    
    // but then change NO to YES in ViewController.m and get another surprise
    // we still use dissolve when we present the LandscapeViewController;
    // coverVertical is used only when dismissing
    // this seems like a bug, but it sure has been around a long time
    // more likely we're just not supposed to do this sort of thing on iPhone
        
}

@end
