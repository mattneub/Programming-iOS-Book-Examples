

#import "ViewController.h"
@import CoreLocation;

@interface ViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager* locman;
@property (nonatomic, strong) NSDate* startTime;
@property (nonatomic) BOOL trying;
@end

@implementation ViewController

- (IBAction) doFindMe: (id) sender {
    BOOL ok = [CLLocationManager locationServicesEnabled];
    if (!ok) {
        NSLog(@"%@", @"Alas");
        return;
    }
    CLAuthorizationStatus stat = [CLLocationManager authorizationStatus];
    if (stat == kCLAuthorizationStatusRestricted ||
        stat == kCLAuthorizationStatusDenied) {
        NSLog(@"%@", @"Oh well");
        return;
    }
    if (self.trying)
        return;
    self.trying = YES;
    CLLocationManager* locman = [CLLocationManager new];
    self.locman = locman;
    locman.delegate = self;
    locman.desiredAccuracy = kCLLocationAccuracyBest;
    locman.activityType = CLActivityTypeFitness;
    self.startTime = nil;
    [self.locman startUpdatingLocation];
}

-(void) stopTrying {
    [self.locman stopUpdatingLocation];
    self.startTime = nil;
    self.trying = NO;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    [self stopTrying];
}

#define REQ_ACC 10
#define REQ_TIME 10

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* loc = locations.lastObject;
    CLLocationAccuracy acc = loc.horizontalAccuracy;
    NSDate* time = loc.timestamp;
    CLLocationCoordinate2D coord = loc.coordinate;
    if (!self.startTime) {
        self.startTime = [NSDate date];
        return; // ignore first attempt
    }
    NSLog(@"%f", acc);
    NSTimeInterval elapsed = [time timeIntervalSinceDate:self.startTime];
    if (elapsed > REQ_TIME) {
        NSLog(@"%@", @"This is taking too long");
        [self stopTrying];
        return;
    }
    if (acc < 0 || acc > REQ_ACC) {
        return; // wait for the next one
    }
    // got it
    NSLog(@"You are at: %f %f", coord.latitude, coord.longitude);
    [self stopTrying];
}

@end
