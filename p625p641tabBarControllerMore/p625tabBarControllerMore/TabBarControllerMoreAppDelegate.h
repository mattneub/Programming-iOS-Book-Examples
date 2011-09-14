

#import <UIKit/UIKit.h>
@class MyDataSource;
@interface TabBarControllerMoreAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) MyDataSource* myDataSource;

@end
