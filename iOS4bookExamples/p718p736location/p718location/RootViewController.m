

#import "RootViewController.h"
#import <MapKit/MapKit.h>

@implementation RootViewController
@synthesize map, locman;

- (void)dealloc
{
    [map release];
    [locman release];
    [super dealloc];
}

- (IBAction)doButton:(id)sender {
    BOOL ok = [CLLocationManager locationServicesEnabled];
    if (!ok) {
        NSLog(@"oh well");
        return;
    }
    CLLocationManager* lm = [[CLLocationManager alloc] init];
    self.locman = lm;
    [lm release];
    self.locman.delegate = self;
    [self.locman startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error {
    NSLog(@"error: %@", [error localizedDescription]);
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    MKCoordinateRegion reg = 
    MKCoordinateRegionMakeWithDistance(coordinate, 600, 600);
    self->map.region = reg;
    MKPointAnnotation* ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = coordinate;
    ann.title = @"You are here";
    [self->map addAnnotation:ann];
    [ann release];
}


@end
