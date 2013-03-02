
#import "AppDelegate.h"
#import "MasterViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    MasterViewController* mvc = [MasterViewController new];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:mvc];
    mvc.restorationIdentifier = @"master";
    nav.restorationIdentifier = @"nav";
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    return YES;
}

-(UIViewController *)applicationNOT:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)ic coder:(NSCoder *)coder {
    if ([[ic lastObject] isEqualToString:@"nav"]) {
        return self.window.rootViewController;
    }
    if ([[ic lastObject] isEqualToString:@"master"]) {
        return [(UINavigationController*)self.window.rootViewController viewControllers][0];
    }

    return nil;
}

// all load, all appear, all decode

@end
