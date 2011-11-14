

#import <UIKit/UIKit.h>

@interface BackgroundColorTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    IBOutlet UIView* view;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (IBAction) doSwitch: (id) sender;

@end

