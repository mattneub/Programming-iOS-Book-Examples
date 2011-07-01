

#import "RootViewController.h"

@implementation RootViewController
@synthesize locman;

- (void)dealloc
{
    [locman release];
    [super dealloc];
}

- (IBAction)doButton:(id)sender {
    CLLocationManager* lm = [[CLLocationManager alloc] init];
    self.locman = lm;
    [lm release];
    self.locman.delegate = self;
    self.locman.headingFilter = 3;
    [self.locman startUpdatingHeading];
}

// run on device, watch console for output

- (void) locationManager:(CLLocationManager *)manager 
        didUpdateHeading:(CLHeading *)newHeading {
    CGFloat h = newHeading.magneticHeading;
    NSString* dir = @"N";
    NSArray* cards = [NSArray arrayWithObjects: @"N", @"NE", @"E", @"SE", 
                      @"S", @"SW", @"W", @"NW", nil];
    for (int i = 0; i < 8; i++)
        if (h < 45.0/2.0 + 45*i) {
            dir = [cards objectAtIndex: i];
            break;
        }
    NSLog(@"%f %@", h, dir);
}


@end
