

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
@property (nonatomic, strong) CMMotionManager* motman;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) IBOutlet UILabel *label;
@end

@implementation ViewController {
    CGFloat oldX, oldY, oldZ;
    NSInteger state;
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
    self->oldX = accel.x * alpha + self->oldX * (1.0 - alpha);
    self->oldY = accel.y * alpha + self->oldY * (1.0 - alpha);
    self->oldZ = accel.z * alpha + self->oldZ * (1.0 - alpha);
}

- (void) pollAccel: (id) dummy {
    CMAccelerometerData* dat = self.motman.accelerometerData;
    CMAcceleration acc = dat.acceleration;
    [self addAcceleration: acc];
    CGFloat x = self->oldX;
    CGFloat y = self->oldY;
    CGFloat z = self->oldZ;
//    CGFloat x = acc.x;
//    CGFloat y = acc.y;
//    CGFloat z = acc.z;
    CGFloat accu = 0.08;
    if (fabs(x) < accu && fabs(y) < accu && z < -0.5) {
        if (state == -1 || state == 1) {
            state = 0;
            self.label.text = @"I'm lying on my back... ahhh...";
        }
    } else {
        if (state == -1 || state == 0) {
            state = 1;
            self.label.text = @"Hey, put me back down on the table!";
        }
    }
}


@end
