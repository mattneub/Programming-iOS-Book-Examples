

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate


#define which 1 // but "2" also works because same-named nib is found automatically


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    RootViewController* theRVC = nil;
    switch (which) {
        case 1:
            theRVC = [[RootViewController alloc] initWithNibName: @"RootView" bundle:nil];
            break;
        case 2:
            theRVC = [RootViewController new];
            break;
    }
    self.window.rootViewController = theRVC; // retains, places view into interface 

    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
