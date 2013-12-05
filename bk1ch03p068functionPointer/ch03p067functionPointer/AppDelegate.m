#import "AppDelegate.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSArray* arr = @[
                     @"Manny",
                     @"Moe",
                     @"Jack",
                     ];
    // we don't actually need the ampersand here, though it's fine to use it
    NSArray* arr2 = [arr sortedArrayUsingFunction:sortByLastCharacter context:nil];
    NSLog(@"%@", arr2);
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new]; // silence runtime warning
    [self.window makeKeyAndVisible];
    return YES;
}

NSInteger sortByLastCharacter(id string1, id string2, void* context) {
    NSString* s1 = string1;
    NSString* s2 = string2;
    NSString* string1end = [s1 substringFromIndex:[s1 length] - 1];
    NSString* string2end = [s2 substringFromIndex:[s2 length] - 1];
    return [string1end compare:string2end];
}



@end
