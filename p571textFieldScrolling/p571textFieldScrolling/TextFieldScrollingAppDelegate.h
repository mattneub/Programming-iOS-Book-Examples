

#import <UIKit/UIKit.h>

@class RootViewController;

@interface TextFieldScrollingAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet RootViewController *viewController;

@property (nonatomic, retain) NSDictionary* states;

@end
