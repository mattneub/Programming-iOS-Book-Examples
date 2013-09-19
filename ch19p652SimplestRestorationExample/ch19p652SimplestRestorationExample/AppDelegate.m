

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    return YES;
}

#define which 0
#if which == 1

-(UIViewController *)application:(UIApplication *)app viewControllerWithRestorationIdentifierPath:(NSArray *)ip coder:(NSCoder *)coder {
    NSLog(@"%@", ip);
    if ([[ip lastObject] isEqualToString:@"nav"]) {
        return self.window.rootViewController;
    }
    if ([[ip lastObject] isEqualToString:@"root"]) {
        return [(UINavigationController*)self.window.rootViewController
                viewControllers][0];
    }
    UIStoryboard* board = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    return [board instantiateViewControllerWithIdentifier:[ip lastObject]];
}

#endif


@end
