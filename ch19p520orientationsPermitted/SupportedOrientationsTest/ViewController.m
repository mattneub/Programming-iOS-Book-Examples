

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

// how to override the application's list of possible orientations
// at the view controller level

-(NSUInteger)supportedInterfaceOrientations {
    // return UIInterfaceOrientationPortrait; // crash!
    // ha ha, you didn't read the docs
    // you don't return an orientation; you return an orientation *mask*
    // (UIInterfaceOrientationMask)
    return UIInterfaceOrientationMaskPortrait;
}

@end
