

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
    // return UIInterfaceOrientationMaskPortraitUpsideDown;
    NSLog(@"supported");
    return UIInterfaceOrientationMaskPortrait;
}

// interesting: quite tricky to get iPhone to assume portrait upside down
// saying it in the supported interface orientations is ignored
// but you can force it at a lower level such as here

// NB what the log proves! we are called *every time* the device rotates
// this is very different from before, when you were called once for all

@end
