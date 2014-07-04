
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
    
    
    
    MyClass* m1 = [MyClass new];
    MyClass* m2 = [MyClass new];
    m1.thing = m2;
    m2.thing = m1;
    
    NSLog(@"%@", @"finished");

    
    
    
    
    
    return YES;
}


@end
