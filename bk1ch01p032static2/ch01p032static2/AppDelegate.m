

#import "AppDelegate.h"

#import "MyClass.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    MyClass* m = [MyClass new];
    NSLog(@"created first MyClass instance, calling doYourThing");
    [m doYourThing];
    m = [MyClass new];
    NSLog(@"created second MyClass instance, calling doYourThing");
    [m doYourThing];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [UIViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end