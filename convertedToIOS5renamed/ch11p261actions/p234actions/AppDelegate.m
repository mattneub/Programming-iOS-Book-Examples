

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) doButton: (id) sender {
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Ooooh!"
                                                 message:@"You sent a nil-targeted action, and the app delegate received it." 
                                                delegate:nil 
                                       cancelButtonTitle:@"Cool"
                                       otherButtonTitles:nil];
    [av show];
}



@end
