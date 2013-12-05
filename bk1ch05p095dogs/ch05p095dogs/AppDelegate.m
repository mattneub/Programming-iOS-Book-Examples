
#import "AppDelegate.h"
#import "Basenji.h"
#import "NoisyDog.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // illustrating polymorphism with self and super
    
    Dog* d = [[Dog alloc] init];
    NSLog(@"This is how a dog barks: %@", [d speak]);
    
    Basenji* b = [[Basenji alloc] init];
    NSLog(@"This is how a basenji barks: %@", [b speak]);
    
    NoisyDog* n = [[NoisyDog alloc] init];
    NSLog(@"This is how a noisy dog barks: %@", [n speak]);
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new]; // silence runtime warning
    [self.window makeKeyAndVisible];
    return YES;
}
@end
