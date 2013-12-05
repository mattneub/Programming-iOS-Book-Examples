

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    id notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self doAlert: notification];
        });
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)n {
    //    NSLog(@"start %@", NSStringFromSelector(_cmd));
    BOOL inactive = ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive);
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Hey" message:[NSString stringWithFormat:@"While %@, I received a local notification: %@", inactive ? @"inactive": @"active", n.alertBody] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
    //    NSLog(@"end %@", NSStringFromSelector(_cmd));
}

- (void) doAlert: (UILocalNotification*) n {
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Hey" message:[NSString stringWithFormat:@"I got launched by a local notification: %@", n.alertBody] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //    NSLog(@"start %@", NSStringFromSelector(_cmd));
    //    NSLog(@"end %@", NSStringFromSelector(_cmd));
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //    NSLog(@"start %@", NSStringFromSelector(_cmd));
    //    NSLog(@"end %@", NSStringFromSelector(_cmd));
}

// logging shows that didReceive is called between willEnter and didBecome


@end
