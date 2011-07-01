

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RootViewController : UIViewController <CLLocationManagerDelegate> {
    
}
@property (nonatomic, retain) CLLocationManager* locman;

@end
