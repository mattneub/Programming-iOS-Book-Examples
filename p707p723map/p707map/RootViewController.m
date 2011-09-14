
#import "RootViewController.h"
#import "MyAnnotationView.h"
#import "MyAnnotation.h"
#import "MyOverlay.h"

@implementation RootViewController
@synthesize map;

- (void)dealloc
{
    [map release];
    [super dealloc];
}

#define which 1 // try 2, 3, 4, 5, 6, 7, 8

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    switch (which) {
        case 1: // figure 34-1
        {
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(34.923964,-120.219558);
            MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
            self->map.region = reg;
            self->map.hidden = NO;
            break;
        }
        case 2: // figure 34-2
        {
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(34.923964,-120.219558);
            MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
            self->map.region = reg;
            MKPointAnnotation* ann = [[MKPointAnnotation alloc] init];
            ann.coordinate = loc;
            ann.title = @"Park here";
            ann.subtitle = @"Fun awaits down the road!";
            [self->map addAnnotation:ann];
            [ann release];
            self->map.hidden = NO;
            break;
        }
        case 3: // set delegate to make pin green, get our own annotation view, etc.
        case 4:
        case 5:
        {
            self->map.delegate = self;
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(34.923964,-120.219558);
            MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
            self->map.region = reg;
            MKPointAnnotation* ann = [[MKPointAnnotation alloc] init];
            ann.coordinate = loc;
            ann.title = @"Park here";
            ann.subtitle = @"Fun awaits down the road!";
            [self->map addAnnotation:ann];
            [ann release];
            self->map.hidden = NO;
            break;
        }
        case 6: // use our own annotation class too
        {
            self->map.delegate = self;
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(34.923964,-120.219558);
            MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
            self->map.region = reg;
            MyAnnotation* ann = [[MyAnnotation alloc] initWithLocation:loc];
            ann.title = @"Park here";
            ann.subtitle = @"Fun awaits down the road!";
            [self->map addAnnotation:ann];
            [ann release];
            self->map.hidden = NO;
            break;
        }
        case 7: // overlay, figure 34-4
        {
            self->map.delegate = self;
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(34.923964,-120.219558);
            MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
            self->map.region = reg;
            MyAnnotation* ann = [[MyAnnotation alloc] initWithLocation:loc];
            ann.title = @"Park here";
            ann.subtitle = @"Fun awaits down the road!";
            [self->map addAnnotation:ann];
            [ann release];
            
            loc = self->map.region.center;
            CGFloat lat = loc.latitude;
            CLLocationDistance metersPerPoint = MKMetersPerMapPointAtLatitude(lat);
            MKMapPoint c = MKMapPointForCoordinate(loc);
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
            [self->map addOverlay:tri];

            self->map.hidden = NO;
            break;
        }
        case 8: // nicer overly, figure 34-5
        {
            self->map.delegate = self;
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(34.923964,-120.219558);
            MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
            self->map.region = reg;
            MyAnnotation* ann = [[MyAnnotation alloc] initWithLocation:loc];
            ann.title = @"Park here";
            ann.subtitle = @"Fun awaits down the road!";
            [self->map addAnnotation:ann];
            [ann release];
            
            // start with our position and derive a nice unit for drawing
            loc = self->map.region.center;
            CGFloat lat = loc.latitude;
            CLLocationDistance metersPerPoint = MKMetersPerMapPointAtLatitude(lat);
            MKMapPoint c = MKMapPointForCoordinate(loc);
            CGFloat unit = 75.0/metersPerPoint;
            // size and position the overlay bounds on the earth
            CGSize sz = CGSizeMake(4*unit, 4*unit);
            MKMapRect mr = MKMapRectMake(c.x + 2*unit, c.y - 4.5*unit, sz.width, sz.height);
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
            MyOverlay* over = [[[MyOverlay alloc] initWithRect:mr] autorelease];
            over.path = [UIBezierPath bezierPathWithCGPath:p];
            CGPathRelease(p);
            // add the overlay to the map
            [self->map addOverlay:over];
            
            self->map.hidden = NO;
            break;

        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView 
            viewForAnnotation:(id <MKAnnotation>)annotation {
    switch (which) {
        case 3:
        {
            MKAnnotationView* v = nil;
            if ([annotation.title isEqualToString:@"Park here"]) {
                static NSString* ident = @"greenPin";
                v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
                if (v == nil) {
                    v = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation 
                                                         reuseIdentifier:ident] 
                         autorelease];
                    ((MKPinAnnotationView*)v).pinColor = MKPinAnnotationColorGreen;
                    v.canShowCallout = YES;
                } else {
                    v.annotation = annotation;
                }
            }
            return v;
            break;
        }
        case 4: // figure 34-3
        {
            MKAnnotationView* v = nil;
            if ([annotation.title isEqualToString:@"Park here"]) {
                static NSString* ident = @"greenPin";
                v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
                if (v == nil) {
                    v = [[[MKAnnotationView alloc] initWithAnnotation:annotation 
                                                      reuseIdentifier:ident] autorelease];
                    v.image = [UIImage imageNamed:@"clipartdirtbike.gif"];
                    CGRect f = v.bounds;
                    f.size.height /= 3.0;
                    f.size.width /= 3.0;
                    v.bounds = f;
                    v.centerOffset = CGPointMake(0,-20);
                    v.canShowCallout = YES;
                } else {
                    v.annotation = annotation;
                }
            }
            return v;
            break;
        }
        case 5: // use custom MKAnnotationView subclass instead
        {
            MKAnnotationView* v = nil;
            if ([annotation.title isEqualToString:@"Park here"]) {
                static NSString* ident = @"bike";
                v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
                if (v == nil) {
                    v = [[[MyAnnotationView alloc] initWithAnnotation:annotation 
                                                      reuseIdentifier:ident] 
                         autorelease];
                    v.canShowCallout = YES;
                } else {
                    v.annotation = annotation;
                }
            }
            return v;
            break;
        }
        case 6: // use custom MKAnnotation too
        case 7:
        case 8:
        {
            MKAnnotationView* v = nil;
            if ([annotation isKindOfClass:[MyAnnotation class]]) { // much better test
                static NSString* ident = @"bike";
                v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
                if (v == nil) {
                    v = [[[MyAnnotationView alloc] initWithAnnotation:annotation 
                                                      reuseIdentifier:ident] 
                         autorelease];
                    v.canShowCallout = YES;
                } else {
                    v.annotation = annotation;
                }
            }
            return v;
            break;
        }
    }
    return nil; // shut the compiler up
}

- (MKOverlayView *)mapView:(MKMapView *)mapView 
            viewForOverlay:(id <MKOverlay>)overlay {
    switch (which) {
        case 7: {
            MKPolygonView* v = nil;
            if ([overlay isKindOfClass:[MKPolygon class]]) {
                v = [[[MKPolygonView alloc] initWithPolygon:(MKPolygon*)overlay] 
                     autorelease];
                v.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
                v.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
                v.lineWidth = 2;
            }
            return v;
            break;
        }
        case 8:
        {
            MKOverlayView* v = nil;
            if ([overlay isKindOfClass: [MyOverlay class]]) {
                v = [[[MKOverlayPathView alloc] initWithOverlay:overlay] autorelease];
                MKOverlayPathView* vv = (MKOverlayPathView*)v; // typecast for simplicity
                vv.path = ((MyOverlay*)overlay).path.CGPath;
                vv.strokeColor = [UIColor blackColor];
                vv.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
                vv.lineWidth = 2;
            }
            return v;
            break;
        }
    }
    return nil; // shut the compiler up
}



@end
