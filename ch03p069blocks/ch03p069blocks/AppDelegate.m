

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSArray* arr = @[
                     @"Manny",
                     @"Moe",
                     @"Jack",
                     ];
    
    NSComparisonResult (^sortByLastCharacter)(id, id) = ^(id obj1, id obj2) {
        NSString* s1 = obj1;
        NSString* s2 = obj2;
        NSString* string1end = [s1 substringFromIndex:[s1 length] - 1];
        NSString* string2end = [s2 substringFromIndex:[s2 length] - 1];
        return [string1end compare:string2end];
    };
    
    NSArray* arr2 = [arr sortedArrayUsingComparator: sortByLastCharacter];
    
    /*
     // or we could have defined the block anonymously inline:
     NSArray* arr2 = [arr sortedArrayUsingComparator: ^(id obj1, id obj2) {
     NSString* s1 = obj1;
     NSString* s2 = obj2;
     NSString* string1end = [s1 substringFromIndex:[s1 length] - 1];
     NSString* string2end = [s2 substringFromIndex:[s2 length] - 1];
     return [string1end compare:string2end];
     }];
     */
    
    
    NSLog(@"%@", arr2);
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new]; // silence runtime warning
    [self.window makeKeyAndVisible];
    return YES;
}


@end
