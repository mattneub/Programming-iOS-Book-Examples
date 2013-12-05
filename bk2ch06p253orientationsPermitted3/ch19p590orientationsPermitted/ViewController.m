

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

// all three are now contributing to the story:
// the plist, the app delegate, and the view controller
// but they must agree! each level down adds a further filter, as it were
// if the app delegate says Landscape,
// the view controller can't say Portrait

-(NSUInteger)supportedInterfaceOrientations {
    // uncomment next line to crash
    // return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskLandscapeRight;
}


@end
