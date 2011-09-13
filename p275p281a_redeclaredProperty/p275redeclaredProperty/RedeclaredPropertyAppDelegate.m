

#import "RedeclaredPropertyAppDelegate.h"
#import "Dog.h"

@implementation RedeclaredPropertyAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    Dog* fido = [[Dog alloc] initWithName:@"Fido"];
    NSLog(@"sure enough, our dog's name is now %@!", fido.name);
    
    // fido.name = @"Rover"; // uncomment; we get an outright error, it is read-only to us
    // fido.zork = @"test"; // uncomment; we get an outright error, it is private, we can't see it
    
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
