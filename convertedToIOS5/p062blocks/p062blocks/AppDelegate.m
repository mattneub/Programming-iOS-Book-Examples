

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSArray* arr = [NSArray arrayWithObjects:
                    @"Manny",
                    @"Moe",
                    @"Jack",
                    nil];
    
    NSComparisonResult (^sortByLastCharacter)(id, id) = ^(id obj1, id obj2) { 
        NSString* s1 = (NSString*) obj1; 
        NSString* s2 = (NSString*) obj2; 
        NSString* string1end = [s1 substringFromIndex:[s1 length] - 1]; 
        NSString* string2end = [s2 substringFromIndex:[s2 length] - 1]; 
        return [string1end compare:string2end];
    }; 
    
    NSArray* arr2 = [arr sortedArrayUsingComparator: sortByLastCharacter];
    NSLog(@"%@", arr2);

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new]; // silence new annoying runtime warning
    [self.window makeKeyAndVisible];
    return YES;
}


@end
