

#import "OverrideSynthesizedAccessorsAppDelegate.h"
#import "MyClass.h"

@implementation OverrideSynthesizedAccessorsAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    MyClass* mc = [[MyClass alloc] init];
    mc.myIvar = [NSNumber numberWithInt: 42];
    mc.myIvar;
    [mc release];
    
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
