

#import "AppDelegate.h"
#import "NSString+MyStringCategories.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [UIViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    NSString* someString = @"Howdy";
    NSString* aName = [someString basePictureName];
    NSLog(@"%@", aName);
    
    
    return YES;
}


@end
