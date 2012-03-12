

#import "SelfAppDelegate.h"
#import "MyClass.h"

@implementation SelfAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Just like p069 example, but now MyClass uses self
    
    MyClass* thing = [[MyClass alloc] init];
    NSLog(@"%@", [thing sayGoodnightGracie]);
    
    // memory management (even though we won't discuss this until Chapter 12)
    [thing release];
    
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
