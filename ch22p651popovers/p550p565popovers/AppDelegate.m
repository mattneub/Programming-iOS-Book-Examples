
#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [[RootViewController alloc] init];
    
    
    // create default defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:
     @{@"choice": @0}];
    
//    /*
    
    // let's do some annoying iOS 5 playing with appearance
    // note how we can use appearanceWhenContainedIn to differentiate cases
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationBar class], [UIPopoverController class], nil]
     setTintColor:[UIColor grayColor]];
    ((UIBarButtonItem*)[UIBarButtonItem appearance]).tintColor = [UIColor brownColor];

    // this looks sort of terrible, but it shows what can be done
    [[UINavigationBar appearanceWhenContainedIn: [UIPopoverController class], nil] setBackgroundColor: [UIColor colorWithRed:0.785 green:0.802 blue:0.827 alpha:1.000]];
//    [[UINavigationBar appearanceWhenContainedIn: [UIPopoverController class], nil] setTintColor: [UIColor redColor]];

    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationBar class], [UIPopoverController class], nil] setBackgroundVerticalPositionAdjustment:4 forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationBar class], [UIPopoverController class], nil]
     setBackButtonBackgroundVerticalPositionAdjustment:4 forBarMetrics:UIBarMetricsDefault];

//     */
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
