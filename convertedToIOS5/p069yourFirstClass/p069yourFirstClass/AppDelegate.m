

#import "AppDelegate.h"
#import "MyClass.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Even though we haven't gotten to instantiation yet,
    // I know you're anxious to try out the brand-new class described on p. 69
    // So here we go!
    
    MyClass* thing = [[MyClass alloc] init];
    NSLog(@"%@", [thing sayGoodnightGracie]);

    // Look, ma, no memory management! ARC will release "thing" for us.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new]; // silence new annoying runtime warning
    [self.window makeKeyAndVisible];
    return YES;
}


@end
