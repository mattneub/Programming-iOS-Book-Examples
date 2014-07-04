

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window =
    [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    RootViewController* rvc = [RootViewController new];
    rvc.restorationIdentifier = @"root";
    UINavigationController* nav =
    [[UINavigationController alloc] initWithRootViewController:rvc];
    nav.restorationIdentifier = @"nav";
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    NSLog(@"app should restore %@", coder);
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    NSLog(@"app should save %@", coder);
    return YES;
}

-(void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"app will encode %@", coder);
}

-(void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"app did decode %@", coder);
}


-(UIViewController *)application:(UIApplication *)app viewControllerWithRestorationIdentifierPath:(NSArray *)ip coder:(NSCoder *)coder {
    NSLog(@"app delegate %@ %@", ip, coder);
    if ([[ip lastObject] isEqualToString:@"nav"]) {
        return self.window.rootViewController;
    }
    if ([[ip lastObject] isEqualToString:@"root"]) {
        return [(UINavigationController*)self.window.rootViewController
                viewControllers][0];
    }
    return nil; // shouldn't happen; the others all have restoration classes
}


							

@end
