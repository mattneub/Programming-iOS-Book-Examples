

#import "Kvo2AppDelegate.h"
#import "MyClass1.h"
#import "MyClass2.h"


@implementation Kvo2AppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MyClass1* objectA = [[MyClass1 alloc] init];
    MyClass2* objectB = [[MyClass2 alloc] init];    
    objectA.value = @"Hello";
    [objectA addObserver:objectB forKeyPath:@"value" 
                 options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                 context:nil];
    objectA.value = @"Goodbye"; // notification is triggered
    
    // memory management
    // remember to unregister! (but if you forget, you should get a nice warning in the console at runtime)
    [objectA removeObserver:objectB forKeyPath:@"value"];
    [objectA release]; [objectB release];
    
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
