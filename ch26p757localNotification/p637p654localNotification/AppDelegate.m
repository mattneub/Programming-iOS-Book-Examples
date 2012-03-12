

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    id notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        [self performSelector:@selector(doAlert:) withObject:notification afterDelay:0.5];
    }

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [RootViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)n {
    BOOL inactive = ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive);
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Hey" message:[NSString stringWithFormat:@"While %@, I received a local notification: %@", inactive ? @"inactive": @"active", n.alertBody] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

- (void) doAlert: (UILocalNotification*) n {
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Hey" message:[NSString stringWithFormat:@"I got launched by a local notification: %@", n.alertBody] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

@end
