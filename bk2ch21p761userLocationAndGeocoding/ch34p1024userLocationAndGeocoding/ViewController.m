

#import "ViewController.h"
@import MapKit;

@interface ViewController () <MKMapViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;
@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    MKUserTrackingBarButtonItem* bbi = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.map];
    self.toolbarItems = @[bbi];
    
    UISearchBar* sb = [UISearchBar new];
    [sb sizeToFit];
    sb.searchBarStyle = UISearchBarStyleMinimal;
    sb.delegate = self;
    self.navigationItem.titleView = sb;
    
    self.map.delegate = self;
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
        
    }
}

- (IBAction) reportAddress: (id) sender {
    CLGeocoder* geo = [CLGeocoder new];
    CLLocation* loc = self.map.userLocation.location;
    [geo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  if (placemarks) {
                      CLPlacemark* p = [placemarks objectAtIndex:0];
                      NSLog(@"you are at: %@", p.addressDictionary); // do something with address
                  }
              }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSString* s = searchBar.text;
    if (!s || s.length < 5)
        return;
    CLGeocoder* geo = [CLGeocoder new];
    [geo geocodeAddressString:s
            completionHandler:^(NSArray *placemarks, NSError *error) {
                if (nil == placemarks) {
                    NSLog(@"%@", error.localizedDescription);
                    return;
                }
                self.map.showsUserLocation = NO;
                CLPlacemark* p = [placemarks objectAtIndex:0];
                MKPlacemark* mp = [[MKPlacemark alloc] initWithPlacemark:p];
                [self.map removeAnnotations:self.map.annotations];
                [self.map addAnnotation:mp];
                [self.map setRegion: MKCoordinateRegionMakeWithDistance
                 (mp.coordinate, 1000, 1000)
                           animated: YES];
            }];
}

- (IBAction) thaiFoodNearMapLocation: (id) sender {
    MKUserLocation* userLoc = self.map.userLocation;
    CLLocation* loc = userLoc.location;
    if (!loc) {
        NSLog(@"%@", @"I don't know where you are now");
        return;
    }
    MKLocalSearchRequest* req = [MKLocalSearchRequest new];
    req.naturalLanguageQuery = @"Thai restaurant";
    req.region = self.map.region;
    MKLocalSearch* search = [[MKLocalSearch alloc] initWithRequest:req];
    [search startWithCompletionHandler:
     ^(MKLocalSearchResponse *response, NSError *error) {
         if (!response) {
             NSLog(@"%@", error);
             return;
         }
         self.map.showsUserLocation = NO;
         MKMapItem* where = response.mapItems[0]; // I'm feeling lucky
         MKPlacemark* place = where.placemark;
         CLLocationCoordinate2D loc = place.location.coordinate;
         MKCoordinateRegion reg =
         MKCoordinateRegionMakeWithDistance(loc, 1200, 1200);
         [self.map setRegion:reg animated:YES];
         MKPointAnnotation* ann = [MKPointAnnotation new];
         ann.title = where.name;
         ann.subtitle = where.phoneNumber;
         ann.coordinate = loc;
         [self.map addAnnotation:ann];
     }];
}

- (IBAction) directionsToThaiFood: (id) sender {
    MKUserLocation* userLoc = self.map.userLocation;
    CLLocation* loc = userLoc.location;
    if (!loc) {
        NSLog(@"%@", @"I don't know where you are now");
        return;
    }
    MKLocalSearchRequest* req = [MKLocalSearchRequest new];
    req.naturalLanguageQuery = @"Thai restaurant";
    req.region = self.map.region;
    MKLocalSearch* search = [[MKLocalSearch alloc] initWithRequest:req];
    [search startWithCompletionHandler:
     ^(MKLocalSearchResponse *response, NSError *error) {
         if (!response) {
             NSLog(@"%@", error);
             return;
         }
         NSLog(@"%@", @"Got restaurant address");
         MKMapItem* where = response.mapItems[0]; // I'm still feeling lucky
         MKDirectionsRequest* req = [MKDirectionsRequest new];
         req.source = [MKMapItem mapItemForCurrentLocation];
         req.destination = where;
         MKDirections* dir = [[MKDirections alloc] initWithRequest:req];
         [dir calculateDirectionsWithCompletionHandler:
          ^(MKDirectionsResponse *response, NSError *error) {
              if (!response) {
                  NSLog(@"%@", error);
                  return;
              }
              NSLog(@"%@", @"got directions");
              MKRoute* route = response.routes[0]; // I'm feeling insanely lucky
              MKPolyline* poly = route.polyline;
              [self.map addOverlay:poly];
              for (MKRouteStep* step in route.steps) {
                  NSLog(@"After %d metres: %@", (int)step.distance, step.instructions);
              }
          }];
     }];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id <MKOverlay>)overlay {
    MKPolylineRenderer* v = nil;
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        v = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline*)overlay];
        v.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.8];
        v.lineWidth = 2;
    }
    return v;
}



@end
