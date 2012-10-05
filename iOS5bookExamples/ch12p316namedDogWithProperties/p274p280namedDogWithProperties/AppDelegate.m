

#import "AppDelegate.h"
#import "Dog.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    Dog* fido = [[Dog alloc] initWithName:@"Fido"];
    NSLog(@"sure enough, our dog's name is now %@!", [fido name]); // could say fido.name
    
    [fido setName: @"Rover"]; // could say fido.name = @"Rover"
    NSLog(@"sure enough, our dog's name is now %@!", [fido name]); // could say fido.name

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc] init]; // silence annoying new warning
    [self.window makeKeyAndVisible];
    return YES;
}

@end
