
#import "TabBarControllerAppDelegate.h"
#import "View1Controller.h"
#import "View2Controller.h"

@implementation TabBarControllerAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    UITabBarController* tbc = [[UITabBarController alloc] init];
    View1Controller* v1c = [[View1Controller alloc] init];
    View2Controller* v2c = [[View2Controller alloc] init];
    [tbc setViewControllers:[NSArray arrayWithObjects:v1c, v2c, nil] animated:NO];
    
    [v1c release]; [v2c release];
    
    self.window.rootViewController = tbc;
    [tbc release];
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
