

#import "AppDelegate.h"
#import "MyClass1.h"
#import "MyClass2.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    MyClass1* objectA = [[MyClass1 alloc] init];
    MyClass2* objectB = [[MyClass2 alloc] init];
    
    [objectA addObserver:objectB 
              forKeyPath:@"theData" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld 
                 context:NULL];
    [objectA.theData removeObjectAtIndex:0]; // notification is triggered
    
    
    [objectA removeObserver:objectB forKeyPath:@"theData"];

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc] init]; // silence warning
    [self.window makeKeyAndVisible];
    return YES;
}

@end
