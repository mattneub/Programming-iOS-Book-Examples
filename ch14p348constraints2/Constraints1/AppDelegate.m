

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

/*
 Like previous example, but IB is not helping us with autolayout (autolayout is off).
 We create the constraints in code.
 
 Build and run in the simulator with the Hardware > Device of the simulator set to iPhone 3.5-inch.
 Then change the Hardware > Device to iPhone 4-inch and run again. The layout still works.
  */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
