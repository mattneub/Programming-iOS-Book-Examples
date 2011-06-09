

#import "CategoryAppDelegate.h"
#import "StringCategories.h"

@implementation CategoryAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"%@", [@"Hello" basePictureName]);
    // proving that we've effectively added a method to NSString
    
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
