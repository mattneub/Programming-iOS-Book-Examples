

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
@property (nonatomic, strong) CMMotionManager* motman;
@property (nonatomic, strong) NSTimer* timer;
@end


@implementation ViewController {
    CGFloat oldX, oldY, oldZ;
    NSTimeInterval oldTime;
    NSInteger lastSlap;
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
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    [self.motman stopAccelerometerUpdates];
}

-(void)addAcceleration:(CMAcceleration)accel {
    double alpha = 0.1;
    self->oldX = accel.x - ((accel.x * alpha) + (self->oldX * (1.0 - alpha)));
    self->oldY = accel.y - ((accel.y * alpha) + (self->oldY * (1.0 - alpha)));
    self->oldZ = accel.z - ((accel.z * alpha) + (self->oldZ * (1.0 - alpha)));
}

- (void) pollAccel: (id) dummy {
    CMAccelerometerData* dat = self.motman.accelerometerData;
    CMAcceleration acc = dat.acceleration;
    [self addAcceleration: acc];
    CGFloat x = self->oldX;
    //    CGFloat y = self->oldY;
    //    CGFloat z = self->oldZ;
    CGFloat thresh = 1.0;
    if ((x < -thresh) || (x > thresh))
        NSLog(@"%f", x);
    if (x < -thresh) {
        if (dat.timestamp - self->oldTime > 0.5 || self->lastSlap == 1) {
            self->oldTime = dat.timestamp;
            self->lastSlap = -1;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(report:) withObject:@"left" afterDelay:0.5];
        }
    }
    if (x > thresh) {
        if (dat.timestamp - self->oldTime > 0.5 || self->lastSlap == -1) {
            self->oldTime = dat.timestamp;
            self->lastSlap = 1;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(report:) withObject:@"right" afterDelay:0.5];
        }
    }
}

- (void) report: (NSString*) s {
    NSLog(@"%@", s);
}


@end
