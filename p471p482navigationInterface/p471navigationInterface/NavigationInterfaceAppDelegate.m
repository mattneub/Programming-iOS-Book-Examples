

#import "NavigationInterfaceAppDelegate.h"
#import "View1Controller.h"


@implementation NavigationInterfaceAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    View1Controller* v1c = [[View1Controller alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:v1c];
    
    [v1c release]; 
    
    self.window.rootViewController = nav;
    [nav release];
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
