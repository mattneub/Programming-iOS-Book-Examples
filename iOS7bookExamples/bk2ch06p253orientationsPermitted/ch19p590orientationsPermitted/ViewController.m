

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

// quite tricky to get iPhone to assume portrait upside down
// saying it in the supported interface orientations Info.plist key is ignored
// but you can force it at a lower level such as here

// we are called *every time* the device rotates


@end
