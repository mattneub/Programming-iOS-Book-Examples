

#import "AppDelegate.h"

#import "ViewController.h"
@import AVFoundation;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:0 error:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:AVAudioSessionInterruptionNotification
     object:nil queue:nil
     usingBlock:^(NSNotification *note) {
         int which = [note.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
         NSLog(@"interruption %@:\n%@", which ? @"began" : @"ended", note.userInfo);
         if (!which) {
             // interruption ended, let's reactivate
             [[AVAudioSession sharedInstance] setActive: YES withOptions: 0 error: nil];
         }
     }];

    

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"interrupter did become active");

    [[AVAudioSession sharedInstance] setActive: YES withOptions: 0 error: nil];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    NSLog(@"in %@", NSStringFromSelector(_cmd)); // never received; the normal situation
}




@end
