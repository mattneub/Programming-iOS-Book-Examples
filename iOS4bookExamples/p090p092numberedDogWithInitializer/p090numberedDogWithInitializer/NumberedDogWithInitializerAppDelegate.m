

#import "NumberedDogWithInitializerAppDelegate.h"
#import "Dog.h"

@implementation NumberedDogWithInitializerAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    Dog* fido = [[Dog alloc] initWithNumber:42];
    int n = [fido number];
    NSLog(@"sure enough, n is now %i!", n);

    // memory management (even though we won't discuss this until Chapter 12)
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
