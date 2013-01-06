

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    BOOL _shouldRotate;
}

// all three are now contributing to the story:
// the plist, the app delegate, and the view controller
// but they must agree! each level down adds a further filter, as it were
// if the app delegate says Landscape,
// the view controller can't say Portrait

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotate {
    return self->_shouldRotate;
}

// rotate and press the button to test attemptRotation and shouldAutorotate

- (IBAction)doButton:(id)sender {
    self->_shouldRotate = !self->_shouldRotate;
    [UIViewController attemptRotationToDeviceOrientation];
}


@end
