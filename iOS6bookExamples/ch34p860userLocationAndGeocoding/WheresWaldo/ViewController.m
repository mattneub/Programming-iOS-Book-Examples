

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIToolbar *barButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    MKUserTrackingBarButtonItem* bbi = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.map];
    self.toolbar.items = @[bbi];
}

- (IBAction)doButton:(id)sender {
    MKMapItem* mi = [MKMapItem mapItemForCurrentLocation];
    NSLog(@"%@", mi);
    [mi openInMapsWithLaunchOptions:@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard)}];
}

- (IBAction)doButton2:(id)sender {
    self.map.showsUserLocation = YES;
}

- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (mapView.userTrackingMode == MKUserTrackingModeNone) {
        CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
        MKCoordinateRegion reg =
        MKCoordinateRegionMakeWithDistance(coordinate, 600, 600);
        mapView.region = reg;
        
        CLGeocoder* geo = [CLGeocoder new];
        CLLocation* loc = userLocation.location;
        [geo reverseGeocodeLocation:loc
                  completionHandler:^(NSArray *placemarks, NSError *error) {
                      if (placemarks) {
                          CLPlacemark* p = [placemarks objectAtIndex:0];
                          NSLog(@"%@", p.addressDictionary); // do something with address
                      }
                  }];
        
    }
}

@end
