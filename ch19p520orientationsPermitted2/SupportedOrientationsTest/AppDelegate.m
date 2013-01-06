

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

// how to override the application's list of possible orientations
// at the application level
// this *overrides* whatever we said in the plist
// however, "all" at this level still means only "all but upside down" on iPhone

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    // uncomment next line to try a different result
    // return UIInterfaceOrientationMaskLandscape;
    return UIInterfaceOrientationMaskAll;
}

// remember to return a mask, not an orientation!


@end
