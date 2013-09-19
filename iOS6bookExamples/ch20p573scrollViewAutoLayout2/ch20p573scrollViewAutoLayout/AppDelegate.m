

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    ViewController* vc = [ViewController new];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    UITabBarController* tab = [UITabBarController new];
    tab.viewControllers = @[nav];
    
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
