

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()
@property (nonatomic, strong) CMMotionManager* motman;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) IBOutlet UILabel *label;
@end

@implementation ViewController {
    CGFloat _oldX, _oldY, _oldZ;
    NSInteger _state;
}

#define which 2 // try also 2

- (void) stopAccelerometer {
    [self.timer invalidate];
    self.timer = nil;
    [self.motman stopAccelerometerUpdates];
    self.label.text = @"";
    _oldX = 0;
    _oldY = 0;
    _oldZ = 0;
    _state = 0;
}

- (IBAction)doButton:(id)sender {
    if (self.motman && self.motman.accelerometerActive) {
        [self stopAccelerometer];
        return;
    }
    if (!self.motman)
        self.motman = [CMMotionManager new];
    if (!self.motman.accelerometerAvailable) {
        NSLog(@"oh well");
        return;
    }
    self.motman.accelerometerUpdateInterval = 1.0 / 30.0;
    
#if which == 1
    
    [self.motman startAccelerometerUpdates];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.motman.accelerometerUpdateInterval target:self selector:@selector(pollAccel:) userInfo:nil repeats:YES];
    
#elif which == 2
    
[self.motman startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
    // should I be using weak-strong dance here?
    if (error) {
        NSLog(@"%@", error);
        [self stopAccelerometer];
        return;
    }
    [self receiveAccel: accelerometerData];
}];
    
#endif
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopAccelerometer];
}

-(void)addAcceleration:(CMAcceleration)accel {
    double alpha = 0.1;
    self->_oldX = accel.x * alpha + self->_oldX * (1.0 - alpha);
    self->_oldY = accel.y * alpha + self->_oldY * (1.0 - alpha);
    self->_oldZ = accel.z * alpha + self->_oldZ * (1.0 - alpha);
}

- (void) pollAccel: (id) dummy {
    CMAccelerometerData* dat = self.motman.accelerometerData;
    CMAcceleration acc = dat.acceleration;
    [self addAcceleration: acc];
    CGFloat x = self->_oldX;
    CGFloat y = self->_oldY;
    CGFloat z = self->_oldZ;
    //    CGFloat x = acc.x;
    //    CGFloat y = acc.y;
    //    CGFloat z = acc.z;
    CGFloat accu = 0.08;
    if (fabs(x) < accu && fabs(y) < accu && z < -0.5) {
        if (self->_state == -1 || self->_state == 1) {
            self->_state = 0;
            self.label.text = @"I'm lying on my back... ahhh...";
        }
    } else {
        if (self->_state == -1 || self->_state == 0) {
            self->_state = 1;
            self.label.text = @"Hey, put me back down on the table!";
        }
    }
}

- (void) receiveAccel: (CMAccelerometerData*) acc {
    [self addAcceleration: acc.acceleration];
    CGFloat x = self->_oldX;
    CGFloat y = self->_oldY;
    CGFloat z = self->_oldZ;
    CGFloat accu = 0.08;
    if (fabs(x) < accu && fabs(y) < accu && z < -0.5) {
        if (self->_state == -1 || self->_state == 1) {
            self->_state = 0;
            self.label.text = @"I'm lying on my back... ahhh...";
        }
    } else {
        if (self->_state == -1 || self->_state == 0) {
            self->_state = 1;
            self.label.text = @"Hey, put me back down on the table!";
        }
    }
}


@end
