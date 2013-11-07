

#import "ViewController.h"
#import "MyAnnotationView.h"
#import "MyAnnotation.h"
#import "MyOverlay.h"
#import "MyOverlayRenderer.h"
@import MapKit;


@interface ViewController () <MKMapViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView* map;
@property (nonatomic) CLLocationCoordinate2D annloc;
@end

@implementation ViewController

#define which 1 // 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.map.tintColor = [UIColor greenColor];
    
    
    CLLocationCoordinate2D loc =
    CLLocationCoordinate2DMake(34.927752,-120.217608);
    MKCoordinateSpan span = MKCoordinateSpanMake(.015, .015);
    MKCoordinateRegion reg = MKCoordinateRegionMake(loc, span);
    // or ...
    // MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(loc, 1200, 1200);
    self.map.region = reg;
    // or ...
//    MKMapPoint pt = MKMapPointForCoordinate(loc);
//    double w = MKMapPointsPerMeterAtLatitude(loc.latitude) * 1200;
//    self.map.visibleMapRect = MKMapRectMake(pt.x - w/2.0, pt.y - w/2.0, w, w);
    
    self.annloc = CLLocationCoordinate2DMake(34.923964,-120.219558);

    
#if which == 1
    return;
#endif
    
    
#if which < 6
    
    
    MKPointAnnotation* ann = [MKPointAnnotation new];
    ann.coordinate = self.annloc;
    ann.title = @"Park here";
    ann.subtitle = @"Fun awaits down the road!";
    [self.map addAnnotation:ann];

#else

    MyAnnotation* ann = [[MyAnnotation alloc] initWithLocation:self.annloc];
    ann.title = @"Park here";
    ann.subtitle = @"Fun awaits down the road!";
    [self.map addAnnotation:ann];


#endif
    
#if which == 8
    
    CGFloat lat = self.annloc.latitude;
    CLLocationDistance metersPerPoint = MKMetersPerMapPointAtLatitude(lat);
    MKMapPoint c = MKMapPointForCoordinate(self.annloc);
    c.x += 150/metersPerPoint;
    c.y -= 50/metersPerPoint;
    MKMapPoint p1 = MKMapPointMake(c.x, c.y);
    p1.y -= 100/metersPerPoint;
    MKMapPoint p2 = MKMapPointMake(c.x, c.y);
    p2.x += 100/metersPerPoint;
    MKMapPoint p3 = MKMapPointMake(c.x, c.y);
    p3.x += 300/metersPerPoint;
    p3.y -= 400/metersPerPoint;
    MKMapPoint pts[3] = {
        p1, p2, p3
    };
    MKPolygon* tri = [MKPolygon polygonWithPoints:pts count:3];
    [self.map addOverlay:tri];

#endif
    
#if which == 9
    
    // start with our position and derive a nice unit for drawing
    CGFloat lat = self.annloc.latitude;
    CLLocationDistance metersPerPoint = MKMetersPerMapPointAtLatitude(lat);
    MKMapPoint c = MKMapPointForCoordinate(self.annloc);
    CGFloat unit = 75.0/metersPerPoint;
    // size and position the overlay bounds on the earth
    CGSize sz = CGSizeMake(4*unit, 4*unit);
    MKMapRect mr =
    MKMapRectMake(c.x + 2*unit, c.y - 4.5*unit, sz.width, sz.height);
    // describe the arrow as a CGPath
    CGMutablePathRef p = CGPathCreateMutable();
    CGPoint start = CGPointMake(0, unit*1.5);
    CGPoint p1 = CGPointMake(start.x+2*unit, start.y);
    CGPoint p2 = CGPointMake(p1.x, p1.y-unit);
    CGPoint p3 = CGPointMake(p2.x+unit*2, p2.y+unit*1.5);
    CGPoint p4 = CGPointMake(p2.x, p2.y+unit*3);
    CGPoint p5 = CGPointMake(p4.x, p4.y-unit);
    CGPoint p6 = CGPointMake(p5.x-2*unit, p5.y);
    CGPoint points[] = {
        start, p1, p2, p3, p4, p5, p6
    };
    // rotate the arrow around its center
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(unit*2, unit*2);
    CGAffineTransform t2 = CGAffineTransformRotate(t1, -M_PI/3.5);
    CGAffineTransform t3 = CGAffineTransformTranslate(t2, -unit*2, -unit*2);
    CGPathAddLines(p, &t3, points, 7);
    CGPathCloseSubpath(p);
    // create the overlay and give it the path
    MyOverlay* over = [[MyOverlay alloc] initWithRect:mr];
    over.path = [UIBezierPath bezierPathWithCGPath:p];
    CGPathRelease(p);
    // add the overlay to the map
    [self.map addOverlay:over];
    
#endif
    
#if which == 10
    
    CGFloat lat = self.annloc.latitude;
    CLLocationDistance metersPerPoint = MKMetersPerMapPointAtLatitude(lat);
    MKMapPoint c = MKMapPointForCoordinate(self.annloc);
    CGFloat unit = 75.0/metersPerPoint;
    // size and position the overlay bounds on the earth
    CGSize sz = CGSizeMake(4*unit, 4*unit);
    MKMapRect mr =
    MKMapRectMake(c.x + 2*unit, c.y - 4.5*unit, sz.width, sz.height);
    MyOverlay* over = [[MyOverlay alloc] initWithRect:mr];
    [self.map addOverlay:over level:MKOverlayLevelAboveRoads];

    MKPointAnnotation* annot = [MKPointAnnotation new];
    annot.coordinate = over.coordinate;
    annot.title = @"This way!";
    [self.map addAnnotation:annot];
    
    

    
#endif
    
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"%@", MKStringFromMapRect(mapView.visibleMapRect));
}

#if which == 3

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView* v = nil;
    if ([annotation.title isEqualToString:@"Park here"]) {
        static NSString* ident = @"greenPin";
        v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
        if (v == nil) {
            v = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                reuseIdentifier:ident];
            ((MKPinAnnotationView*)v).pinColor = MKPinAnnotationColorGreen;
            v.canShowCallout = YES;
            ((MKPinAnnotationView*)v).animatesDrop = YES;

        }
        v.annotation = annotation;
    }
    return v;
}

#endif

#if which == 4

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView* v = nil;
    if ([annotation.title isEqualToString:@"Park here"]) {
        static NSString* ident = @"greenPin";
        v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
        if (v == nil) {
            v = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                             reuseIdentifier:ident];
            v.image = [UIImage imageNamed:@"clipartdirtbike.gif"];
            CGRect f = v.bounds;
            f.size.height /= 3.0;
            f.size.width /= 3.0;
            v.bounds = f;
            v.centerOffset = CGPointMake(0,-20);
            v.canShowCallout = YES;
        }
        v.annotation = annotation;
    }
    return v;
}

#endif

#if which == 5

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView* v = nil;
    if ([annotation.title isEqualToString:@"Park here"]) {
        static NSString* ident = @"bike";
        v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
        if (v == nil) {
            v = [[MyAnnotationView alloc] initWithAnnotation:annotation
                                             reuseIdentifier:ident];
            v.canShowCallout = YES;
        }
        v.annotation = annotation;
    }
    return v;
}

#endif

#if which >= 6

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView* v = nil;
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        static NSString* ident = @"bike";
        v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
        if (v == nil) {
            v = [[MyAnnotationView alloc] initWithAnnotation:annotation
                                             reuseIdentifier:ident];
            v.canShowCallout = YES;
            UIImage* im = [UIImage imageNamed:@"smileyWithTransparencyTiny.png"];
            im = [im imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView* iv = [[UIImageView alloc] initWithImage:im];
            v.leftCalloutAccessoryView = iv;
            v.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
        }
        v.annotation = annotation;
    }
    return v;
}

#endif

#if which >= 7

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (MKAnnotationView* aView in views) {
        if ([aView.reuseIdentifier isEqualToString:@"bike"]) {
            aView.transform = CGAffineTransformMakeScale(0, 0);
            aView.alpha = 0;
            [UIView animateWithDuration:0.8 animations:^{
                aView.alpha = 1;
                aView.transform = CGAffineTransformIdentity;
            }];
        }
    }
}


#endif

#if which == 8

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id <MKOverlay>)overlay {
    MKPolygonRenderer* v = nil;
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        v = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon*)overlay];
        v.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
        v.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
        v.lineWidth = 2;
    }
    return v;
}

#endif

#if which == 9


- (MKOverlayRenderer*)mapView:(MKMapView*)mapView
           rendererForOverlay:(id <MKOverlay>)overlay {
    MKOverlayRenderer* v = nil;
    if ([overlay isKindOfClass: [MyOverlay class]]) {
        v = [[MKOverlayPathRenderer alloc] initWithOverlay:overlay];
        MKOverlayPathRenderer* vv = (MKOverlayPathRenderer*)v;
        vv.path = ((MyOverlay*)overlay).path.CGPath;
        vv.strokeColor = [UIColor blackColor];
        vv.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        vv.lineWidth = 2;
    }
    return v;
}


#endif

#if which == 10

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id <MKOverlay>)overlay {
    MKOverlayRenderer* v = nil;
    if ([overlay isKindOfClass: [MyOverlay class]]) {
        v = [[MyOverlayRenderer alloc] initWithOverlay: overlay
                                             angle: -M_PI/3.5];
    }
    return v;
}


#endif

- (IBAction) showPOIinMapsApp: (id) sender {
    MKPlacemark* p =
    [[MKPlacemark alloc] initWithCoordinate:self.annloc
                          addressDictionary:nil];
    MKMapItem* mi = [[MKMapItem alloc] initWithPlacemark: p];
    mi.name = @"A Great Place to Dirt Bike"; // label to appear in Maps app
    NSValue* span = [NSValue valueWithMKCoordinateSpan:self.map.region.span];
    [mi openInMapsWithLaunchOptions:
     @{MKLaunchOptionsMapTypeKey: @(MKMapTypeHybrid),
       MKLaunchOptionsMapSpanKey: span
       }
     ];
}



@end
