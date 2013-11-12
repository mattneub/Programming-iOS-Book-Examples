

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //    NSLog(@"start %@", NSStringFromSelector(_cmd));

    // Override point for customization after application launch.
    
    //    NSLog(@"end %@", NSStringFromSelector(_cmd));

    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //    NSLog(@"start %@", NSStringFromSelector(_cmd));
    ViewController* viewController = (ViewController*)self.window.rootViewController;
    [viewController displayPDF:url];
    //    NSLog(@"end %@", NSStringFromSelector(_cmd));
    return YES;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    //    NSLog(@"start %@", NSStringFromSelector(_cmd));
    //    NSLog(@"end %@", NSStringFromSelector(_cmd));
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //    NSLog(@"start %@", NSStringFromSelector(_cmd));
    //    NSLog(@"end %@", NSStringFromSelector(_cmd));
}

// logging shows that handleOpenURL: comes *between* willEnter and didBecome

							

@end
