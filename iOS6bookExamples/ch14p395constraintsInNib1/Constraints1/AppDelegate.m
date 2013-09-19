

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

/*
 Example shows constraints laid out in Interface Builder.
 
 Build and run in the simulator with the Hardware > Device of the simulator set to iPhone 3.5-inch.
 Then change the Hardware > Device to iPhone 4-inch and run again. The layout still works.
 
 Without constraints, you'd have to fix the layout in code; there's no way to do with this with springs and struts alone.
 
 Also demonstrates a way of checking the whole hierarchy for ambiguous layout during debugging.
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
