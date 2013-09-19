

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
    
    
    
    MyClass* mc = [MyClass new];
    
    // can't even compile unless MyClass adopts NSCopying
    MyClass* mc2 = [mc copyWithZone: nil];

    
    
    return YES;
}


@end
