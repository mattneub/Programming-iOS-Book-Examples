

#import "AppDelegate.h"

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

void routeChangeCallback(void* userData, AudioSessionPropertyID id, UInt32 sz, const void* val) {
    CFDictionaryRef d = val;
    NSLog(@"%@", (__bridge NSDictionary*)d);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: NULL];
    [[AVAudioSession sharedInstance] setDelegate: self];
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, 
                                    &routeChangeCallback, NULL);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[AVAudioSession sharedInstance] setActive: YES error: NULL];
}

-(void)beginInterruption {
    NSLog(@"begin");
}

- (void)endInterruptionWithFlags:(NSUInteger)flags {
    NSLog(@"flags: %i", flags);
}


@end
