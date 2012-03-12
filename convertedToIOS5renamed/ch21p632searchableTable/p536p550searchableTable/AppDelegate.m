
#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    RootViewController* rvc = [[RootViewController alloc] initWithNibName:@"RootView" bundle:nil];
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController: rvc];
    self.window.rootViewController = nc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
