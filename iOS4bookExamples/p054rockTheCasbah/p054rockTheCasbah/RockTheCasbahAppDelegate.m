

#import "RockTheCasbahAppDelegate.h"

@implementation RockTheCasbahAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    NSString* s = @"Hello, world!";
    [s rockTheCasbah]; // compiler merely warns
                       // but when we run the app, we'll actually crash
    
    
    
    
    
        
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
