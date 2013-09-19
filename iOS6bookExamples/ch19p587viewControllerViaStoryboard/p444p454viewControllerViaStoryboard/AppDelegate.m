

#import "AppDelegate.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Nothing here! No window, no view controller, no nib, no nothing
    // Everything happens through the automatic loading of the storyboard
    // (see the target, and the Info.plist where UIMainStoryboardFile is set)
    // The storyboard supplies the window...
    // ...instantiates the root view controller (set in the storyboard as ViewController)...
    // ...and sets the window's rootViewController
    // The view controller's view is drawn directly in the storyboard
    
    
    return YES;
}

@end
