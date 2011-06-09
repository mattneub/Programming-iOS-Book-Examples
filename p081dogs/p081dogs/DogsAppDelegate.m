
#import "DogsAppDelegate.h"
#import "Dog.h"
#import "Basenji.h"
#import "NoisyDog.h"

@implementation DogsAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // illustrating polymorphism with self and super
    
    Dog* d = [[Dog alloc] init];
    NSLog(@"This is how a dog barks: %@", [d speak]);
    
    Basenji* b = [[Basenji alloc] init];
    NSLog(@"This is how a basenji barks: %@", [b speak]);
    
    NoisyDog* n = [[NoisyDog alloc] init];
    NSLog(@"This is how a noisy dog barks: %@", [n speak]);
    
    // memory management (even though we won't discuss this until Chapter 12)
    [d release]; [b release]; [n release];
    
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
