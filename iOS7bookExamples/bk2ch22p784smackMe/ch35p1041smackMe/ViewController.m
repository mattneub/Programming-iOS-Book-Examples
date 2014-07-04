

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()
@property (nonatomic, strong) CMMotionManager* motman;
@property (nonatomic, strong) NSTimer* timer;
@end


@implementation ViewController {
    CGFloat _oldX, _oldY, _oldZ;
    NSTimeInterval _oldTime;
    NSInteger _lastSlap;
}


- (IBAction)doButton:(id)sender {
    self.motman = [CMMotionManager new];
    if (!self.motman.accelerometerAvailable) {
        NSLog(@"oh well");
        return;
    }
    self.motman.accelerometerUpdateInterval = 1.0 / 30.0;
    [self.motman startAccelerometerUpdates];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.motman.accelerometerUpdateInterval target:self selector:@selector(pollAccel:) userInfo:nil repeats:YES];
    
    NSLog(@"%@", @"starting");
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    [self.motman stopAccelerometerUpdates];
}

-(void)addAcceleration:(CMAcceleration)accel {
    double alpha = 0.1;
    self->_oldX = accel.x - ((accel.x * alpha) + (self->_oldX * (1.0 - alpha)));
    self->_oldY = accel.y - ((accel.y * alpha) + (self->_oldY * (1.0 - alpha)));
    self->_oldZ = accel.z - ((accel.z * alpha) + (self->_oldZ * (1.0 - alpha)));
}

- (void) pollAccel: (id) dummy {
    CMAccelerometerData* dat = self.motman.accelerometerData;
    CMAcceleration acc = dat.acceleration;
    [self addAcceleration: acc];
    CGFloat x = self->_oldX;
    //    CGFloat y = self->oldY;
    //    CGFloat z = self->oldZ;
    CGFloat thresh = 1.0;
    if ((x < -thresh) || (x > thresh))
        NSLog(@"%f", x);
    if (x < -thresh) {
        if (dat.timestamp - self->_oldTime > 0.5 || self->_lastSlap == 1) {
            self->_oldTime = dat.timestamp;
            self->_lastSlap = -1;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(report:) withObject:@"left" afterDelay:0.5];
        }
    }
    if (x > thresh) {
        if (dat.timestamp - self->_oldTime > 0.5 || self->_lastSlap == -1) {
            self->_oldTime = dat.timestamp;
            self->_lastSlap = 1;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(report:) withObject:@"right" afterDelay:0.5];
        }
    }
}

- (void) report: (NSString*) s {
    NSLog(@"%@", s);
}


@end
