

#import "YourFirstClassAppDelegate.h"
#import "MyClass.h"

@implementation YourFirstClassAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Even though we haven't gotten to instantiation yet,
    // I know you're anxious to try out the brand-new class described on p. 69
    // So here we go!
    
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
