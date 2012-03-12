

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

// LLVM 3.0 likes to see a function prototype (declaration), such as:
// NSInteger sortByLastCharacter(id, id, void*);
// However, I've turned off this warning in this project

NSInteger sortByLastCharacter(id string1, id string2, void* context) { 
    NSString* s1 = (NSString*) string1; 
    NSString* s2 = (NSString*) string2; 
    NSString* string1end = [s1 substringFromIndex:[s1 length] - 1]; 
    NSString* string2end = [s2 substringFromIndex:[s2 length] - 1]; 
    return [string1end compare:string2end];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSArray* arr = [NSArray arrayWithObjects:
                    @"Manny",
                    @"Moe",
                    @"Jack",
                    nil];
    NSArray* arr2 = [arr sortedArrayUsingFunction:&sortByLastCharacter context:NULL];
    NSLog(@"%@", arr2);

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new]; // silence new annoying runtime warning
    [self.window makeKeyAndVisible];
    return YES;
}


@end
