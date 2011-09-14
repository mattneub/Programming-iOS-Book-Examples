
#import "RootViewController.h"

@implementation RootViewController
@synthesize label;

- (void)dealloc
{
    [label release];
    [super dealloc];
}

- (IBAction)doButton:(id)sender {
    state = -1;
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.05];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

-(void)addAcceleration:(UIAcceleration*)accel {
    double alpha = 0.1;
    self->oldX = accel.x * alpha + self->oldX * (1.0 - alpha);
    self->oldY = accel.y * alpha + self->oldY * (1.0 - alpha);
    self->oldZ = accel.z * alpha + self->oldZ * (1.0 - alpha);
}

- (void)accelerometer:(UIAccelerometer *)accelerometer 
        didAccelerate:(UIAcceleration *)acceleration {
    [self addAcceleration: acceleration];
    CGFloat x = self->oldX;
    CGFloat y = self->oldY;
    CGFloat z = self->oldZ;
    CGFloat accu = 0.08;
    if (fabs(x) < accu && fabs(y) < accu && z < -0.5) {
        if (state == -1 || state == 1) {
            state = 0;
            self->label.text = @"I'm lying on my back... ahhh...";
        }
    } else {
        if (state == -1 || state == 0) {
            state = 1;
            self->label.text = @"Hey, put me back down on the table!";
        }
    }
}


@end
