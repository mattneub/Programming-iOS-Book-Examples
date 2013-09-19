

#import "AppDelegate.h"
#import "MyClass.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // proving that even a *local* static variable (i.e. in a method) is a class-level variable
    
    MyClass* m = [MyClass new];
    NSLog(@"created first MyClass instance, calling doYourThing");
    [m doYourThing];
    m = [MyClass new];
    NSLog(@"created second MyClass instance, calling doYourThing");
    [m doYourThing];
    
    // thus "static" is not a solution when the goal is to do something once per *instance*
    // but of course you can use it in class methods, or in a singleton
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [UIViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
