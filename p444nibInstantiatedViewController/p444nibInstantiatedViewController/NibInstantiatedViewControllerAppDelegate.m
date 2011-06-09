

#import "NibInstantiatedViewControllerAppDelegate.h"

@implementation NibInstantiatedViewControllerAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // RootViewController is instantiated in the nib and hooked up as the window's rootViewController
    // its view is also drawn directly in the nib
    // to see an example where its view is loaded from another nib,
    // just make a new project based on the View-Based Application Template
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
