
#import "Empty_WindowAppDelegate.h"
#import "MyClass.h"

@implementation Empty_WindowAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    MyClass* mc = [[MyClass alloc] init];
    // look at the warning(s) caused by this next line; see also MyClass.h
    MyClass* mc2 = [mc copyWithZone: [mc zone]];
    
    // memory management (actually we'll crash before we get here)
    [mc2 release]; [mc release];
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
