

#import "AppDelegate.h"
#import "Dog.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // changed the purpose of the example
    // instead of showing how to declare a property, I now save that to chapter 12
    // here, we make the accessors public, thus enabling property syntax without the declaration
    Dog* fido = [[Dog alloc] init];
    fido.number = 42; 
    int n = fido.number;
    NSLog(@"sure enough, n is now %i!", n);

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new]; // silence runtime warning
    [self.window makeKeyAndVisible];
    return YES;
}

@end
