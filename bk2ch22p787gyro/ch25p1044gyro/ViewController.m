

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()
@property (nonatomic, strong) CMMotionManager* motman;
@property (nonatomic, strong) NSTimer* timer;
@end


@implementation ViewController

- (IBAction)doButton:(id)sender {
    self.motman = [CMMotionManager new];
    if (!self.motman.deviceMotionAvailable) {
        NSLog(@"oh well");
        return;
    }
    CMAttitudeReferenceFrame f = CMAttitudeReferenceFrameXMagneticNorthZVertical;
    if (([CMMotionManager availableAttitudeReferenceFrames] & f) == 0) {
        NSLog(@"darn");
        return;
    }
    self.motman.showsDeviceMovementDisplay = YES;
    self.motman.deviceMotionUpdateInterval = 1.0 / 30.0;
    [self.motman startDeviceMotionUpdatesUsingReferenceFrame:f];
    NSTimeInterval t = self.motman.deviceMotionUpdateInterval * 10;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:t target:self selector:@selector(pollAttitude:) userInfo:nil repeats:YES];
    
    NSLog(@"%@", @"starting");
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    [self.motman stopDeviceMotionUpdates];
}

- (void) pollAttitude: (id) dummy {
    CMDeviceMotion* mot = self.motman.deviceMotion;
    if (mot.magneticField.accuracy <= CMMagneticFieldCalibrationAccuracyLow) {
        NSLog(@"%d", mot.magneticField.accuracy);
        return; // not ready yet
    }
    CMAttitude* att = mot.attitude;
    CGFloat to_deg = 180.0 / M_PI;
    NSLog(@"%f %f %f", att.pitch * to_deg, att.roll * to_deg, att.yaw * to_deg);
    CMAcceleration g = mot.gravity;
    NSLog(@"pitch is tilted %@", g.z > 0 ? @"forward" : @"back");
}




@end
