

#import "AppDelegate.h"
#import "MyClass.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    MyClass* mc = [[MyClass alloc] init];
    // look at the warning(s) caused by this next line; see also MyClass.h
    MyClass* mc2 = [mc copyWithZone: nil];
    // ARC is stricter about unimplemented methods, so we fail to build at this point...
    // ...unless of course we declare that MyClass conforms to NSCopying
    // If we *do* declare that MyClass conforms to NSCopying, then...
    // ... we build successfully, as before, but with a warning of incomplete implementation
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
