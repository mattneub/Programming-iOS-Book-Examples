

#import "AppDelegate.h"

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate () <UIApplicationDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:AVAudioSessionInterruptionNotification
     object:nil queue:nil
     usingBlock:^(NSNotification *note) {
         int which = [note.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
         NSLog(@"interruption %@:\n%@", which ? @"began" : @"ended", note.userInfo);
     }];

    
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
    return; // comment out to test immediate presentation of notification by background app
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UILocalNotification* ln = [[UILocalNotification alloc] init];
        ln.alertBody = @"Testing";
        [[UIApplication sharedApplication] presentLocalNotificationNow:ln];
    });
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
    NSLog(@"in %@", NSStringFromSelector(_cmd));
    
}


- (void)applicationWillTerminate:(UIApplication *)application {

    NSLog(@"in %@", NSStringFromSelector(_cmd));
}




@end
