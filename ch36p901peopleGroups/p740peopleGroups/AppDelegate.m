

#import "AppDelegate.h"

#import "DocumentLister.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize ubiq = _ubiq;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:[[DocumentLister alloc] init]];
    self.window.rootViewController = nav;
    
//    NSFileManager* fm = [NSFileManager new];
//    NSURL* ubiq = [fm URLForUbiquityContainerIdentifier:nil];
//    NSLog(@"ubiq: %@", ubiq);
//    self.ubiq = ubiq;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
