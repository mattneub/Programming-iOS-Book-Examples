

#import "AppDelegate.h"
#import "MyClass1.h"
#import "MyClass2.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    MyClass1* objectA = [[MyClass1 alloc] init];
    MyClass2* objectB = [[MyClass2 alloc] init];    
    // register for KVO
    [objectA addObserver:objectB forKeyPath:@"value" options:0 context:nil];
    // change the value in a KVO compliant way
    objectA.value = @"Hello, world!";
    
    // remember to unregister! (but if you forget, you should get a nice warning in the console at runtime)
    [objectA removeObserver:objectB forKeyPath:@"value"];
    // in real life this is the kind of thing for which you might still need a dealloc
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
