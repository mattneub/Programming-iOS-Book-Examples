

#import "AppDelegate.h"
#import "MyClass1.h"
#import "MyClass2.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    MyClass1* objectA = [[MyClass1 alloc] init];
    MyClass2* objectB = [[MyClass2 alloc] init];    
    objectA.value = @"Hello";
    [objectA addObserver:objectB forKeyPath:@"value" 
                 options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                 context: nil];
    objectA.value = @"Goodbye"; // notification is triggered
    
    // remember to unregister! (but if you forget, you should get a nice warning in the console at runtime)
    [objectA removeObserver:objectB forKeyPath:@"value"];

    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc] init]; 
    [self.window makeKeyAndVisible];
    return YES;
}
@end
