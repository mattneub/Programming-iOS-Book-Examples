

#import "AppDelegate.h"
#import "Dog.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // showing the syntax for properties
    // Dog's accessors for number are not public...
    // ...but a property is declared so we can call them using property syntax
    Dog* fido = [[Dog alloc] init];
    fido.number = 42; 
    int n = fido.number;
    NSLog(@"sure enough, n is now %i!", n);

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new]; // silence new annoying runtime warning
    [self.window makeKeyAndVisible];
    return YES;
}

@end
