

#import "AppDelegate.h"
#import "Dog.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // showing that instance variables and accessors work
    Dog* fido = [Dog new];
    [fido setNumber: 42];
    int n = [fido number];
    NSLog(@"sure enough, n is now %d!", n);
    
    // showing that key-value coding also works
    NSNumber* num = @4242; // numeric object literal
    [fido setValue: num forKey: @"number"];
    num = [fido valueForKey: @"number"];
    n = [num intValue];
    
    NSLog(@"sure enough, n is now %d!", n);
    

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new]; // silence runtime warning
    [self.window makeKeyAndVisible];
    return YES;
}


@end
