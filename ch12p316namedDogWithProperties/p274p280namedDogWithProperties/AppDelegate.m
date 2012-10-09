

#import "AppDelegate.h"
#import "Dog.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // (reversed getter/setter syntax so I'm using dot-syntax by default)
    
    Dog* fido = [[Dog alloc] initWithName:@"Fido"];
    NSLog(@"sure enough, our dog's name is now %@!", fido.name); // could say [fido name]
    
    fido.name = @"Rover"; // could say [fido setName: @"Rover"]
    NSLog(@"sure enough, our dog's name is now %@!", fido.name); // could say [fido name]

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
