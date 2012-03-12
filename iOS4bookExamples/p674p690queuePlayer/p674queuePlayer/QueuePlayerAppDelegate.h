

#import <UIKit/UIKit.h>
@class AVQueuePlayer;

@interface QueuePlayerAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) AVQueuePlayer* qp;
@end
