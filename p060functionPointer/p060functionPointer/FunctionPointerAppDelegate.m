

#import "FunctionPointerAppDelegate.h"

@implementation FunctionPointerAppDelegate


@synthesize window=_window;

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
    
    
    
    
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}



- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
