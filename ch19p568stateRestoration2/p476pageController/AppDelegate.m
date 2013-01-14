

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

/* How to test state restoration:
 Run on the device or simulator. Get into a state. On the device or simulator, click Home.
 (On the simulator, that's Shift-Command-H.)
 This will cause state to be saved in good order.
 Back on the computer, stop the running project. Then run again from the computer to the dev/sim.
 This will cause the app on the device/simulator to attempt to load with restoration.
 */

// same as previous example, but we do give root view controller a restoration class

/*
 sequence if rvc was showing:
 
 appwillfinish
 appshouldrestore
 rvc (
 root
 )
 rvc decode
 appdiddecode
 appdidfinish
 
 sequence if pep was showing:
 
 appwillfinish
 appshouldrestore
 rvc (
 root
 )
 pep (
 root,
 pep
 )
 rvc decode
 pep decode
 appdiddecode
 appdidfinish

 */

// must move creation of the root view controller to willFinish,
// so that a root view controller exists at restoration time (see event sequences above)
// thus may as well move *everything* to willFinish
// you will rarely need didFinish, which happens after the whole restoration ends

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"appwillfinish");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [RootViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // everything got moved to willFinish
    NSLog(@"appdidfinish");
    return YES;
}

// must implement both and return YES to get restoration

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    NSLog(@"appshouldrestore");
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    NSLog(@"appshouldsave");
    return YES;
}

// could do last-minute post-restoration stuff here if coder is needed

-(void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"appdiddecode");
}

-(void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"appwillencode");
}

@end
