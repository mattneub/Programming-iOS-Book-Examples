

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    NSLog(@"start %@", NSStringFromSelector(_cmd));
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
//    NSLog(@"end %@", NSStringFromSelector(_cmd));
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    NSLog(@"start %@", NSStringFromSelector(_cmd));
    [self.viewController displayPDF:url];
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
