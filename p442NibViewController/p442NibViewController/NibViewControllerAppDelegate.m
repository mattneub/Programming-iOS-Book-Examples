

#import "NibViewControllerAppDelegate.h"
#import "RootViewController.h"

@implementation NibViewControllerAppDelegate


@synthesize window=_window;

#define which 1 // but "2" also works because same-named nib is found automatically

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RootViewController* theRVC = nil;
    switch (which) {
        case 1:
            theRVC = [[RootViewController alloc] initWithNibName: @"RootView" bundle:nil];
            break;
        case 2:
            theRVC = [[RootViewController alloc] init];
            break;
    }
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
