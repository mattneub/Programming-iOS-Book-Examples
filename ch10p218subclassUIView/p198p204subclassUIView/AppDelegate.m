

#import "AppDelegate.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [[UIViewController alloc] initWithNibName: @"View" bundle:nil];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
