

#import "SelfSizingLabelAppDelegate.h"

@implementation SelfSizingLabelAppDelegate


@synthesize window=_window;
@synthesize theLabel = _theLabel;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    [self.theLabel performSelector:@selector(sizeToFit) withObject:nil afterDelay:1];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [_theLabel release];
    [super dealloc];
}

@end
