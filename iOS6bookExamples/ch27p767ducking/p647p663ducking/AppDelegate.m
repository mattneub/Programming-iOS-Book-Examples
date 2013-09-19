

#import "AppDelegate.h"

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface AppDelegate () <UIApplicationDelegate, AVAudioSessionDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient
                                     withOptions:0 error: nil];
    // iOS 6, delegate deprecated, use notifications instead
    // [[AVAudioSession sharedInstance] setDelegate: self];
    // iOS 6, AudioToolbox C interface deprecated, use new Objective-C capabilities instead
    //AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,
    //                                routeChangeCallback, nil);
    
    // new in iOS 6, we can sign up for notifications
    // I am intentionally leaking the observers and self, no harm done
    [[NSNotificationCenter defaultCenter]
     addObserverForName:AVAudioSessionRouteChangeNotification
     object:nil queue:nil
     usingBlock:^(NSNotification *note) {
         NSLog(@"change %@", note.userInfo);
     }];
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"%@", @"app became active");
    [[AVAudioSession sharedInstance] setActive: YES withOptions: 0 error: nil];
}


@end
