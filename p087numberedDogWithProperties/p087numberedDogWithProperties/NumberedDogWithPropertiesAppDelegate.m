

#import "NumberedDogWithPropertiesAppDelegate.h"
#import "Dog.h"

@implementation NumberedDogWithPropertiesAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // showing the syntax for properties
    // Dog's accessors for number are not public...
    // ...but a property is declared so we can call them using property syntax
    Dog* fido = [[Dog alloc] init];
    fido.number = 42; 
    int n = fido.number;
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
