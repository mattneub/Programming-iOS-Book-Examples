

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new]; // silence new annoying runtime warning
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL) respondsToSelector: (SEL) sel { 
    NSLog(@"%@", NSStringFromSelector(sel)); 
    return [super respondsToSelector:(sel)];
}


@end
