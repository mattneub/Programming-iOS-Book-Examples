

#import "AppDelegate.h"
#import "MyClass.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [UIViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    MyClass* mc = [[MyClass alloc] init];
    mc.myIvar = [NSNumber numberWithInt: 42];
    id dummy = mc.myIvar;
    NSLog(@"%@", dummy); // added this to prove we are accessing this "property"

    
    return YES;
}


@end
