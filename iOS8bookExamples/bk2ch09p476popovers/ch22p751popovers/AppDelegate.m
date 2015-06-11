

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // create default defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"choice": @0}];

    return YES;
}
							

@end
