

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CLLocationManager* locman;
@property (nonatomic, weak) IBOutlet UILabel* lab;
@end

@implementation ViewController
@synthesize locman=_locman, lab=_lab;

- (IBAction)doButton:(id)sender {
    if (self.locman && !self.lab.hidden) {
        [self.locman stopUpdatingHeading];
        self.lab.hidden = YES;
        return;
    }
    BOOL ok = [CLLocationManager headingAvailable];
    if (!ok) {
        NSLog(@"drat");
        return;
    }
    CLLocationManager* lm = [[CLLocationManager alloc] init];
    self.locman = lm;
    self.locman.delegate = self;
    self.locman.headingFilter = 3;
    self.locman.headingOrientation = CLDeviceOrientationPortrait;
    // self.locman.purpose = @"This app would like to tell you which way you're facing.";
    [self.locman startUpdatingHeading];
}

// run on device

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error {
    NSLog(@"error: %@", [error localizedDescription]);
    // e.g. if user refuses to authorize...
    // ..."The operation couldn't be completed."
    [manager stopUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager 
        didUpdateHeading:(CLHeading *)newHeading {
    CGFloat h = newHeading.magneticHeading;
    CGFloat h2 = newHeading.trueHeading; // will be -1
    __block NSString* dir = @"N";
    NSArray* cards = [NSArray arrayWithObjects: 
                      @"N", @"NE", @"E", @"SE", 
                      @"S", @"SW", @"W", @"NW", 
                      nil];
    [cards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (h < 45.0/2.0 + 45*idx) {
            dir = obj;
            *stop = YES;
        }
    }];
    if (self.lab.hidden)
        self.lab.hidden = NO;
    if (![self.lab.text isEqualToString:dir])
        self.lab.text = dir;
    NSLog(@"%f %f %@", h, h2, dir);
}


@end
