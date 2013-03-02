

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

/*
 sequence of events if root view was showing:
 
 appwillfinish
 appshouldrestore
 app (
 root
 )
 rvc decode
 appdiddecode
 appdidfinish

 (Note that the app(root) step is purely for demonstration purposes.
 Normally you wouldn't bother implementing viewControllerWithRestorationIdentifierPath here.
 The right thing will happen all by itself: the runtime will obtain the root view controller.)
 
 sequence of events if a pep boy was showing:
 
 appwillfinish
 appshouldrestore
 app (
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

// this next method should be deleted!
// it is unnecessary; I'm just showing it in order to clarify the event sequence
// and to show how to implement it so that we restore in good order
// the key thing is to return the *existing* rootViewController

-(UIViewController *)application:(UIApplication *)application
    viewControllerWithRestorationIdentifierPath:(NSArray *)ic
                           coder:(NSCoder *)coder {
    NSLog(@"app %@", ic);
    UIViewController* vc = nil;
    NSString* id = [ic lastObject];
    if ([id isEqualToString:@"root"])
        vc = self.window.rootViewController; // !!! return existing controller!
    return vc;
}

@end
