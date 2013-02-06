

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) IBOutlet MKMapView *map;
@property (nonatomic, strong) CLLocationManager* locman;
@property (nonatomic, strong) NSDate* startTime;
@property (nonatomic) BOOL gotloc;
@end

@implementation ViewController

- (IBAction)doButton:(id)sender {
    // authorization interface is different because older,
    // and because it can be toggled as a whole, over and above this app
    BOOL ok = [CLLocationManager locationServicesEnabled];
    if (!ok) {
        NSLog(@"oh well");
        return;
    }
    CLAuthorizationStatus auth = [CLLocationManager authorizationStatus];
    if (auth == kCLAuthorizationStatusRestricted || auth == kCLAuthorizationStatusDenied) {
        NSLog(@"sigh");
        return;
    }
    CLLocationManager* lm = [CLLocationManager new];
    self.locman = lm;
    self.locman.delegate = self;
    self.locman.desiredAccuracy = kCLLocationAccuracyBest;
    // purpose property deprecated in iOS 6: use info.plist instead
    // self.locman.purpose = @"This app would like to tell you where you are.";
    self.startTime = [NSDate date]; // now
    self.gotloc = NO;
    [self.locman startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error {
    NSLog(@"error: %@", [error localizedDescription]);
    // e.g. if user refuses to authorize...
    // ..."The operation couldn't be completed."
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
    
    if (!self.gotloc && ([newLocation.timestamp timeIntervalSinceDate:self.startTime] > 20)) {
        NSLog(@"this is just taking too long");
        [self.locman stopUpdatingLocation];
        return;
    }
    CLLocationAccuracy acc = newLocation.horizontalAccuracy;
    NSLog(@"%f", acc);
    if (acc > 70)
        return; // wait for better accuracy
    // if we get here, we have an accurate location
    [manager stopUpdatingLocation];
    self.gotloc = YES;
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    MKCoordinateRegion reg = 
        MKCoordinateRegionMakeWithDistance(coordinate, 600, 600);
    self.map.region = reg;
    MKPointAnnotation* ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = coordinate;
    ann.title = @"You are here";
    [self.map addAnnotation:ann];
}


@end
