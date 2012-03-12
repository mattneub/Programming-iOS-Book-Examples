

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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"interrupter did become active");

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];

    [[AVAudioSession sharedInstance] setDelegate: self];
}

- (void)beginInterruption {
    NSLog(@"interrupter begin being interrupted");
}

- (void)endInterruption { // in case we have to handle audio session interruption
    NSLog(@"interrupter ended being interrupted");
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
}


@end
