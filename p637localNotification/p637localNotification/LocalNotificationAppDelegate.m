

#import "LocalNotificationAppDelegate.h"

#import "RootViewController.h"

@implementation LocalNotificationAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    id notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        [self performSelector:@selector(doAlert:) withObject:notification afterDelay:0.5];
    }
     
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)n {
    BOOL inactive = ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive);
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Hey" message:[NSString stringWithFormat:@"While %@, I received a local notification: %@", inactive ? @"inactive": @"active", n.alertBody] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    [av release];
}

- (void) doAlert: (UILocalNotification*) n {
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Hey" message:[NSString stringWithFormat:@"I got launched by a local notification: %@", n.alertBody] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    [av release];
}

@end
