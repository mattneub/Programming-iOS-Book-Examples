

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    // note: nil nib name doesn't work for table view controllers! we must give the name explicitly
    // (and by the same token, "new" or alloc-init doesn't work either)
    // same bug from previous systems carries forward
    self.window.rootViewController = [[RootViewController alloc] initWithNibName:@"RootView" bundle:nil];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
