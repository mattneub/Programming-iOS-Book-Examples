

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    // uncomment next line to try a different result
    // return UIInterfaceOrientationMaskLandscape;
    return UIInterfaceOrientationMaskAll; // still means "all but upside down"
}
							

@end
