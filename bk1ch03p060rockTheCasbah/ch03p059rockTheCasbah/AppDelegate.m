
#import "AppDelegate.h"
#import "MyClass.h"

@implementation AppDelegate

/*
 - (NSString*) rockTheCasbah {
 return @"Hello";
 }
*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSString* s = @"Hello, world!";
    //[(MyClass*)s rockTheCasbah];
    id unk = s;
    [unk rockTheCasbah]; // if we don't *either* import "MyClass.h" *or* provide our own rockTheCasbah, "no known instance method for selector 'rockTheCasbah'"
    // if we can manage to compile and run, then of course we get "unrecognized selector" at runtime
    
    // interesting side effect of using ARC here:
    // ARC regards [s rockTheCasbah] as worth a fatal compile error, not a mere warning
    // in order to fool it and demonstrate what happens when we send a non-implemented message,
    // we must *both* cast to MyClass (which has a rockTheCasbah)
    // or cast to id (to get dynamic messaging)...
    // *and* show it some rockTheCasbah method (so there's a method signature and at least a fighting chance of success)
    
    // Also, if you uncomment the conflicting rockTheCasbah method above,
    // while also importing MyClass, ARC won't just warn;
    // it refuses to compile: "Multiple methods named 'rockTheCasbah' found with mismatched result, parameter type or attributes"
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}




@end
