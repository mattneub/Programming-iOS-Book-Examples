

#import "AppDelegate.h"

#import "ViewController.h"
@import AVFoundation;

@interface AppDelegate () <UIApplicationDelegate>
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation AppDelegate

-(void) fired: (id) sender {
    NSLog(@"timer fired");
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:AVAudioSessionInterruptionNotification
     object:nil queue:nil
     usingBlock:^(NSNotification *note) {
         int which = [note.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
         NSLog(@"interruption %@:\n%@", which ? @"began" : @"ended", note.userInfo);
     }];

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

    NSLog(@"in %@", NSStringFromSelector(_cmd));
    
    return; // fascinating experiment
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fired:) userInfo:nil repeats:YES];

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    NSLog(@"in %@", NSStringFromSelector(_cmd));
    NSLog(@"state while entering background: %ld", (long)[application applicationState]);
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

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:0 error:nil];
    [[AVAudioSession sharedInstance] setActive:YES withOptions:0 error:nil];
    NSLog(@"in %@", NSStringFromSelector(_cmd));
    
}

// kill the app from the app switcher while it's playing, and you will see it actually receives this!

- (void)applicationWillTerminate:(UIApplication *)application {

    NSLog(@"in %@", NSStringFromSelector(_cmd));
}




@end
