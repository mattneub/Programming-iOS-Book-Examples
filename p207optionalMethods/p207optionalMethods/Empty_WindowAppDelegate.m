

#import "Empty_WindowAppDelegate.h"

@implementation Empty_WindowAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}


- (BOOL) respondsToSelector: (SEL) sel { 
    NSLog(@"%@", NSStringFromSelector(sel)); 
    return [super respondsToSelector:(sel)];
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
