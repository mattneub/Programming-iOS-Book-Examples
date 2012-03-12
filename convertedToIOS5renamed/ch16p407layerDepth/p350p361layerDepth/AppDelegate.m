

#import "AppDelegate.h"
#import "CompassView.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    
    CompassView* v = [[CompassView alloc] initWithFrame:CGRectMake(42,56,240,240)];
    [self.window.rootViewController.view addSubview:v];
    
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
