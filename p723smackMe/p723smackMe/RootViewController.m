
#import "RootViewController.h"

@implementation RootViewController

- (void)dealloc
{
    [super dealloc];
}

- (IBAction)doButton:(id)sender {
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.05];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

-(void)addAcceleration:(UIAcceleration*)accel {
    double alpha = 0.1;
    self->oldX = accel.x - ((accel.x * alpha) + (self->oldX * (1.0 - alpha)));
    self->oldY = accel.y - ((accel.y * alpha) + (self->oldY * (1.0 - alpha)));
    self->oldZ = accel.z - ((accel.z * alpha) + (self->oldZ * (1.0 - alpha)));
}

- (void)accelerometer:(UIAccelerometer *)accelerometer 
        didAccelerate:(UIAcceleration *)acceleration {
    [self addAcceleration: acceleration];
    CGFloat x = self->oldX;
//    CGFloat y = self->oldY;
//    CGFloat z = self->oldZ;
    CGFloat thresh = 1.0;
    if (x < -thresh) {
        if (acceleration.timestamp - self->oldTime > 0.5 || self->lastSlap == 1) {
            self->oldTime = acceleration.timestamp;
            self->lastSlap = -1;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(report:) withObject:@"left" afterDelay:0.5];
        }
    }
    if (x > thresh) {
        if (acceleration.timestamp - self->oldTime > 0.5 || self->lastSlap == -1) {
            self->oldTime = acceleration.timestamp;
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
