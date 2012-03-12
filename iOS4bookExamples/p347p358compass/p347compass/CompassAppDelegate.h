

#import <UIKit/UIKit.h>
@class CompassView;

@interface CompassAppDelegate : NSObject <UIApplicationDelegate> {
    CompassView *_compass;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CompassView *compass;

@end
