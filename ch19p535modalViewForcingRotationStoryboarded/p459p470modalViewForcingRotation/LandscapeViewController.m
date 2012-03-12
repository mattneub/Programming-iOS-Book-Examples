
#import "LandscapeViewController.h"


@implementation LandscapeViewController



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    return io == UIInterfaceOrientationLandscapeRight;
}

- (IBAction)doRotate:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    // in this case, using the storyboard doesn't actually save us anything much
    // in fact, it's slightly more code than before
    // returning to a presenting scene is still done exactly as before
    
    // however, I think one should not look at storyboarding as a way of saving code
    // rather, it's a way of structuring the architecture more coherently
    // this was an interesting experiment but not a terribly useful example
}

@end

