

#import "AppDelegate.h"
#import "Dog.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{


    Dog* fido = [[Dog alloc] initWithName:@"Fido"];
    NSLog(@"sure enough, our dog's name is now %@!", fido.name); //
    // note that I can use property notation with formal property declaration
    // this is not well explained (if at all) in the previous editions
    
    // uncomment this and the setter in Dog to test setting
    // fido.name = @"Rover"; //
    // NSLog(@"sure enough, our dog's name is now %@!", fido.name); //
    // and once again I'm using property notation without formal property declaration
    // both for setting and for getting

    // uncomment this to test that we crash in debug build if we try to make a dog with pure init
    // (note that asserts are turned off by default in release build)
    // Dog* nameless = [[Dog alloc] init];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new]; 
    [self.window makeKeyAndVisible];
    return YES;
}


@end
