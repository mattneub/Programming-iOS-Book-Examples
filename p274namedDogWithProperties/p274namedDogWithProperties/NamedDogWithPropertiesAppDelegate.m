

#import "NamedDogWithPropertiesAppDelegate.h"
#import "Dog.h"

@implementation NamedDogWithPropertiesAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    Dog* fido = [[Dog alloc] initWithName:@"Fido"];
    NSLog(@"sure enough, our dog's name is now %@!", [fido name]); // could say fido.name
    
    [fido setName: @"Rover"]; // could say fido.name = @"Rover"
    NSLog(@"sure enough, our dog's name is now %@!", [fido name]); // could say fido.name
    
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
