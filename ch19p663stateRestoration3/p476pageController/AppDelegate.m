

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) NSArray* pep;
@end

@implementation AppDelegate

// did becomes will

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.window.rootViewController = [RootViewController new];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

// answer yes to the two big questions

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    
    NSLog(@"%@", [coder decodeObjectForKey:UIApplicationStateRestorationBundleVersionKey]);
    
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    return YES;
}


@end
