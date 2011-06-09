

#import "NamedDogAppDelegate.h"
#import "Dog.h"

@implementation NamedDogAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    Dog* fido = [[Dog alloc] initWithName:@"Fido"];
    NSLog(@"sure enough, our dog's name is now %@!", [fido name]);
    
//    [fido setName: @"Rover"];
//    NSLog(@"sure enough, our dog's name is now %@!", [fido name]);
    
    [fido release];

    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
