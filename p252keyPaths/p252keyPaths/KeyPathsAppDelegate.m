

#import "KeyPathsAppDelegate.h"
#import "MyClass.h";

@implementation KeyPathsAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MyClass* myObject = [[MyClass alloc] init];
    // access via key path
    NSLog(@"%@", [myObject valueForKeyPath:@"theData.name"]);
    // access via facade
    NSLog(@"%@", [myObject valueForKey: @"pepBoys"]);
    // access via facade & key path
    NSLog(@"%@", [myObject valueForKeyPath:@"pepBoys.name"]);
    // mutable access via facade
    NSMutableArray* marr = [myObject mutableArrayValueForKey: @"pepBoys"];
    [marr removeObjectAtIndex:0];
    NSLog(@"%@", marr);
    // proof that we really did mutate
    NSLog(@"%@", [myObject valueForKey: @"pepBoys"]);
    
    [myObject release];
    
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
