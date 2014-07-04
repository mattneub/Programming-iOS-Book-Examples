

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    BOOL _shouldRotate;
}

-(NSUInteger)supportedInterfaceOrientations {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    NSLog(@"supported, device %ld", (long)orientation);
    if (orientation)
      NSLog(@"self %ld", (long)self.interfaceOrientation);
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotate {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    NSLog(@"should, device %ld", (long)orientation);
    if (orientation)
        NSLog(@"self %ld", (long)self.interfaceOrientation);
    return self->_shouldRotate;
}

// rotate and press the button to test attemptRotation and shouldAutorotate

- (IBAction)doButton:(id)sender {
    self->_shouldRotate = !self->_shouldRotate;
    [UIViewController attemptRotationToDeviceOrientation];
}

// rotation events check


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

// layout events check

-(void)viewWillLayoutSubviews {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

-(void)viewDidLayoutSubviews {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

-(void)updateViewConstraints {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [super updateViewConstraints];
}
 


@end
