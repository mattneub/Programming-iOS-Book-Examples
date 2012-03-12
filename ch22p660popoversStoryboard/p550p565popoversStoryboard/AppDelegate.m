

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    // create default defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInt:0],
      @"choice",
      nil]];
    
    // let's do some annoying iOS 5 playing with appearance
    // note how we can use appearanceWhenContainedIn to differentiate cases
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationBar class], [UIPopoverController class], nil]
     setTintColor:[UIColor grayColor]];
    [[UIBarButtonItem appearance] setTintColor: [UIColor brownColor]];
    
    // this looks sort of terrible, but it shows what can be done
    [[UINavigationBar appearanceWhenContainedIn: [UIPopoverController class], nil] setBackgroundColor: [UIColor colorWithRed:0.785 green:0.802 blue:0.827 alpha:1.000]];
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationBar class], [UIPopoverController class], nil] setBackgroundVerticalPositionAdjustment:4 forBarMetrics:UIBarMetricsDefault];   
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationBar class], [UIPopoverController class], nil]
     setBackButtonBackgroundVerticalPositionAdjustment:4 forBarMetrics:UIBarMetricsDefault];

    
    return YES;
}
							

@end
