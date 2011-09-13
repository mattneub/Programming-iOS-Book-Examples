
#import "NumberedDogAppDelegate.h"
#import "Dog.h"

@implementation NumberedDogAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // showing that instance variables and accessors work
    Dog* fido = [[Dog alloc] init];
    [fido setNumber: 42];
    int n = [fido number];
    NSLog(@"sure enough, n is now %i!", n);
    
    // showing that key-value coding also works
    // note that this corrects an error in the book (also corrected in second printing)
    NSString* s = @"number";
    [fido setValue: [NSNumber numberWithInt:4242] forKey: s];
    NSNumber* nn = [fido valueForKey: s];
    NSLog(@"sure enough, nn is now %@!", nn);
    
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
