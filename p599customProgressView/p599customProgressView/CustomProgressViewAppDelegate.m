

#import "CustomProgressViewAppDelegate.h"

#import "RootViewController.h"

@implementation CustomProgressViewAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
