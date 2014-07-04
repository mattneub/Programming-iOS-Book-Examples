

#import "AppDelegate.h"
#import "MyClass1.h"
#import "MyClass2.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [UIViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    MyClass1* objectA = [MyClass1 new];
    MyClass2* objectB = [MyClass2 new];
    objectA.value = @"Hello";
    
    // register
    [objectA addObserver:objectB forKeyPath:@"value"
                 options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                 context: nil];
    objectA.value = @"Goodbye"; // notification is triggered
    
    // unregister
    [objectA removeObserver:objectB forKeyPath:@"value"];
    

    
    
    
    return YES;
}


@end
