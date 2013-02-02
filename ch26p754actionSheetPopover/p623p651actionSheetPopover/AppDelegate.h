

#import <UIKit/UIKit.h>

#define APPDEL ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIPopoverController* currentPop;

@end
