

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
    
    [objectA addObserver:objectB
              forKeyPath:@"theData" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                 context:nil];
    [objectA.theData removeObjectAtIndex:0]; // notification is triggered
    
    
    [objectA removeObserver:objectB forKeyPath:@"theData"];

    
    
    return YES;
}


@end
