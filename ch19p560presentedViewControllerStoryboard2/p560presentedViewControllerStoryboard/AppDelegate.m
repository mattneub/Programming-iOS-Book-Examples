

#import "AppDelegate.h"
#import "RootViewController.h"
#import "MyNavigationController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [[MyNavigationController alloc] initWithRootViewController:[RootViewController new]];
    [self.window makeKeyAndVisible];

    return YES;
}
							

@end
