

#import "PrivateMethodAppDelegate.h"
#import "MyClass.h"

@implementation PrivateMethodAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MyClass* m = [[MyClass alloc] init];
    NSLog(@"%@", [m publicMethod]);
          
    // NSLog(@"%@", [m myMethod]); // uncomment; it works, but at least compiler warns; that's the point

    // memory management (even though we won't discuss this until Chapter 12)
    [m release];
    
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
