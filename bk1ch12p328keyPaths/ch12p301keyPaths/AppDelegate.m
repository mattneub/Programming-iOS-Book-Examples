

#import "AppDelegate.h"
#import "MyClass.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    MyClass* myObject = [MyClass new];
    // access via key path
    NSLog(@"theData.name:\n%@", [myObject valueForKeyPath:@"theData.name"]);
    // access via facade
    id proxy = [myObject valueForKey: @"pepBoys"];
    NSLog(@"pepBoys (%@):\n%@", [proxy class], proxy);
    // access via facade & key path
    NSLog(@"pepBoys.name:\n%@", [myObject valueForKeyPath:@"pepBoys.name"]);
    // mutable access via facade
    NSMutableArray* marr = [myObject mutableArrayValueForKey: @"pepBoys"];
    [marr removeObjectAtIndex:0];
    NSLog(@"fetch mutable array and remove first element:\n%@", marr);
    // proof that we really did mutate
    NSLog(@"pepBoys:\n%@", [myObject valueForKey: @"pepBoys"]);

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [UIViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
