

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class MKMapView;

@interface RootViewController : UIViewController <CLLocationManagerDelegate> {
    
    MKMapView *map;
}
@property (nonatomic, retain) IBOutlet MKMapView *map;
@property (nonatomic, retain) CLLocationManager* locman;
@end
