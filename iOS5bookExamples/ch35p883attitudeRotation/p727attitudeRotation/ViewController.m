

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "MyView.h"

@interface ViewController ()
@property (nonatomic, strong) CMMotionManager* motman;
@property (nonatomic, strong) NSTimer* timer;
@end


@implementation ViewController {
    IBOutlet MyView* v;
    CMAttitude* ref;
}
@synthesize motman, timer;


- (IBAction) doButton:(id)sender {
    
    self->ref = nil; // start over if user presses button again
    
    self.motman = [CMMotionManager new];
    if (!motman.deviceMotionAvailable) {
        NSLog(@"oh well");
        return;
    }
    CMAttitudeReferenceFrame f = CMAttitudeReferenceFrameXArbitraryCorrectedZVertical;
    if (([CMMotionManager availableAttitudeReferenceFrames] & f) == 0) {
        NSLog(@"darn");
        return;
    }
    self.motman.deviceMotionUpdateInterval = 1.0 / 30.0;
    [self.motman startDeviceMotionUpdatesUsingReferenceFrame:f];
    NSTimeInterval t = self.motman.deviceMotionUpdateInterval;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:t target:self selector:@selector(pollAttitude:) userInfo:nil repeats:YES];
}

- (void) pollAttitude: (id) dummy {
    CMDeviceMotion* mot = self.motman.deviceMotion;
    CMAttitude* att = mot.attitude;
    if (!self->ref) {
        self->ref = att;
        NSLog(@"got ref %f %f %f", att.pitch, att.roll, att.yaw);
        return;
    }
    [att multiplyByInverseOfAttitude:self->ref];
    CMRotationMatrix r = att.rotationMatrix;
    
    CATransform3D t = CATransform3DIdentity;
    t.m11 = r.m11;
    t.m12 = r.m12;
    t.m13 = r.m13;
    t.m21 = r.m21;
    t.m22 = r.m22;
    t.m23 = r.m23;
    t.m31 = r.m31;
    t.m32 = r.m32;
    t.m33 = r.m33;
    
    
    CALayer* lay = [[self->v.layer sublayers] objectAtIndex:0];
    [CATransaction setDisableActions:YES];
    
    lay.transform = t;
}

@end
