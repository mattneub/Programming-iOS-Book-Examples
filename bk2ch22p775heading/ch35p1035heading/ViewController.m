

#import "ViewController.h"
@import CoreLocation;

@interface ViewController () <CLLocationManagerDelegate>
@property (nonatomic, weak) IBOutlet UILabel* lab;
@property (nonatomic, strong) CLLocationManager* locman;
@end

@implementation ViewController

- (IBAction) doStart: (id) sender {
    if (self.locman) {
        return;
    }
    BOOL ok = [CLLocationManager headingAvailable];
    if (!ok) {
        NSLog(@"drat");
        return;
    }
    CLLocationManager* lm = [CLLocationManager new];
    self.locman = lm;
    self.locman.delegate = self;
    self.locman.headingFilter = 5;
    self.locman.headingOrientation = CLDeviceOrientationPortrait;
    [self.locman startUpdatingHeading];
    // [self.locman startUpdatingLocation];
}

- (IBAction) doStop: (id) sender {
    if (self.locman) {
        [self.locman stopUpdatingHeading];
        [self.locman stopUpdatingLocation];
        self.lab.text = @"";
        self.locman = nil;
    }
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error {
    [self doStop:nil];
}

-(void)locationManager:(CLLocationManager *)manager
      didUpdateHeading:(CLHeading *)newHeading {
    CGFloat h = newHeading.magneticHeading;
    CGFloat h2 = newHeading.trueHeading; // will be -1 unless also updating location
    if (h2 > 0)
        h = h2;
    __block NSString* dir = @"N";
    NSArray* cards = @[@"N", @"NE", @"E", @"SE",
                       @"S", @"SW", @"W", @"NW"];
    [cards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (h < 45.0/2.0 + 45*idx) {
            dir = obj;
            *stop = YES;
        }
    }];
    if (![self.lab.text isEqualToString:dir])
        self.lab.text = dir;
    NSLog(@"%f %f %@", h, h2, dir);
    // NSLog(@"%@", newHeading);
}

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations {
    //NSLog(@"%@", locations.lastObject);
}

@end
