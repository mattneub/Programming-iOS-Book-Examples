

#import "AppDelegate.h"
#import "Dog.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // showing property syntax for calling accessors
    Dog* fido = [Dog new];
    fido.number = 42;
    int n = fido.number;
    NSLog(@"sure enough, n is now %d!", n);
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new]; // silence runtime warning
    [self.window makeKeyAndVisible];
    return YES;
}


@end
