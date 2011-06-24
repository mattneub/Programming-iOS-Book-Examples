

#import "DuckingAppDelegate.h"

#import "RootViewController.h"

#import <AVFoundation/AVFoundation.h>

@implementation DuckingAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: NULL];
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[AVAudioSession sharedInstance] setActive: YES error: NULL];
}


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
