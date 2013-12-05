

#import "AppDelegate.h"
@import AVFoundation;

@implementation AppDelegate {
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient
                                     withOptions: 0 error: nil];

    
    // I am intentionally leaking the observers and self, no harm done
    [[NSNotificationCenter defaultCenter]
     addObserverForName:AVAudioSessionRouteChangeNotification
     object:nil queue:nil
     usingBlock:^(NSNotification *note) {
         NSLog(@"change %@", note.userInfo);
         NSLog(@"current route %@", [[AVAudioSession sharedInstance] currentRoute]);
     }];
    [[NSNotificationCenter defaultCenter]
     addObserverForName:AVAudioSessionInterruptionNotification
     object:nil queue:nil
     usingBlock:^(NSNotification *note) {
         int which = [note.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
         NSLog(@"interruption %@:\n%@", which ? @"began" : @"ended", note.userInfo);
     }];

    
    
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"%@", @"app became active");
    [[AVAudioSession sharedInstance] setActive: YES withOptions: 0 error: nil];
}

							
@end
