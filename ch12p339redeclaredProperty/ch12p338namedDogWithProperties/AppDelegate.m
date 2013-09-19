

#import "AppDelegate.h"
#import "Dog.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [UIViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    Dog* fido = [[Dog alloc] initWithName:@"Fido"];
    NSLog(@"sure enough, our dog's name is now %@!", fido.name);
    
    [fido dummy]; // I exposed dummy method in header and added this call
    // this proves that although *we* cannot set Dog name or access zork, Dog can
    
    // fido.name = @"Rover"; // uncomment; we get an outright compile error, it is read-only to us
    // fido.zork = @"test"; // uncomment; we get an outright compile error, it is private, we can't see it

    
    return YES;
}


@end
