

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface RootViewController : UIViewController <MKMapViewDelegate> {
    
    MKMapView *map;
}
@property (nonatomic, retain) IBOutlet MKMapView *map;

@end
