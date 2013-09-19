

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    // OMG, iOS 6 finally fixes nib-loading bug with table view controllers
    // so, this next line finds RootView.xib just like any other view controller would
    self.window.rootViewController = [RootViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
