

#import "ManualViewControllerAppDelegate.h"
#import "RootViewController.h"

@implementation ManualViewControllerAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RootViewController* theRVC = [[RootViewController alloc] init];
    self.window.rootViewController = theRVC; // retains, places view into interface 
    [theRVC release];

    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
