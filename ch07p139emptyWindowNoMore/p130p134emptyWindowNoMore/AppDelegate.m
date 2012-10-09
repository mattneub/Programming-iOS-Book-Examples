

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate


// the purpose of this example is merely to show that editing a nib edits the real interface
// ... without our writing any code

// but Apple got rid of the nib in the empty window project template,
// so in order to demonstrate this, we have to start with the "single view" application template

// the code below was already present in the template; all we did was drag the button into the view

// in iOS 6 / Xcode 4.5 the nib for a new project has autolayout turned on
// we'll get to that later; however, it means a different set of guidelines from before

// also the button now has a title "Button"

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
