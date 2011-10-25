

#import "KvoOnMutableArrayAppDelegate.h"
#import "MyClass1.h"
#import "MyClass2.h"

@implementation KvoOnMutableArrayAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MyClass1* objectA = [[MyClass1 alloc] init];
    MyClass2* objectB = [[MyClass2 alloc] init];
    
    [objectA addObserver:objectB 
              forKeyPath:@"theData" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld 
                 context:nil];
    [objectA.theData removeObjectAtIndex:0]; // notification is triggered
    
    
    [objectA removeObserver:objectB forKeyPath:@"theData"];
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
