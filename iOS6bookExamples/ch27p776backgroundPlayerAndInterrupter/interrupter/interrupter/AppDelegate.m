

#import "AppDelegate.h"

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:0 error:nil];
    
    // iOS 6 uses notifications instead of delegate
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

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"interrupter did become active");

    [[AVAudioSession sharedInstance] setActive: YES withOptions: 0 error: nil];

}



@end
