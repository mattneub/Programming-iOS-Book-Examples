

#import "AppDelegate.h"

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>


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


- (void)applicationWillResignActive:(UIApplication *)application {

    NSLog(@"in %@", NSStringFromSelector(_cmd));
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    NSLog(@"in %@", NSStringFromSelector(_cmd));
    NSLog(@"state while entering background: %i", [application applicationState]);
    
    // [self performSelector:@selector(notify) withObject:nil afterDelay:5];
}

- (void) notify {
    UILocalNotification* ln = [[UILocalNotification alloc] init];
    ln.alertBody = @"Testing";
    [[UIApplication sharedApplication] presentLocalNotificationNow:ln];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"got local notification reading %@", notification.alertBody);
}



- (void)applicationWillEnterForeground:(UIApplication *)application {

    NSLog(@"in %@", NSStringFromSelector(_cmd));
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setDelegate: self];
    NSLog(@"in %@", NSStringFromSelector(_cmd));
    
}


- (void)applicationWillTerminate:(UIApplication *)application {

    NSLog(@"in %@", NSStringFromSelector(_cmd));
}

- (void)beginInterruption {
    NSLog(@"in %@", NSStringFromSelector(_cmd));
}

-(void)endInterruptionWithFlags:(NSUInteger)flags {
    NSLog(@"in %@", NSStringFromSelector(_cmd));
}



@end
