
#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // UICollectionView must have a layout manager from the get-go
    // Since we are creating our view implicitly as part of UICollectionViewController...
    // ...we must tell the controller what layout to use
    RootViewController* rvc = [[RootViewController alloc]
                               initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController: rvc];
    self.window.rootViewController = nc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
