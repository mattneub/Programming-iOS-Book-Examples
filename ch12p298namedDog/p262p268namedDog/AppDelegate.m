

#import "AppDelegate.h"
#import "Dog.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{


    Dog* fido = [[Dog alloc] initWithName:@"Fido"];
    NSLog(@"sure enough, our dog's name is now %@!", [fido name]);
    
    // uncomment this and the setter in Dog to test setting
    // [fido setName: @"Rover"];
    // NSLog(@"sure enough, our dog's name is now %@!", [fido name]);

    // uncomment this to test that we crash in debug build if we try to make a dog with pure init
    // (note that asserts are turned off by default in release build)
    // unfortunately NSAssert behavior in iOS 5 is poor: the reason string is never logged!
    // (appears to be a Snow Leopard Xcode bug; works okay on Lion)
    // Dog* nameless = [[Dog alloc] init];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new]; // silence new annoying runtime warning
    [self.window makeKeyAndVisible];
    return YES;
}


@end
