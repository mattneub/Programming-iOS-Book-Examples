

#import "AppDelegate.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL) respondsToSelector: (SEL) sel { 
    NSLog(@"%@", NSStringFromSelector(sel)); 
    return [super respondsToSelector:(sel)];
    // some undocumented methods now appear, including _applicationLaunchesIntoPortrait:
    // might be a bug
}


@end
