
#import "AppDelegate.h"
#import "MyClass.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    MyClass* mc = [[MyClass alloc] init];
    mc.myIvar = [NSNumber numberWithInt: 42];
    id dummy;
    dummy = mc.myIvar;
    NSLog(@"%@", dummy); // added this to prove we are accessing this "property"

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc] init]; // silence warning
    [self.window makeKeyAndVisible];
    return YES;
}

@end
