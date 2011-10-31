
#import "AppDelegate.h"
#import "MyClass.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    MyClass* mc = [[MyClass alloc] init]; 
    [[NSBundle mainBundle] loadNibNamed:@"MyNib" owner:mc options:nil]; 
    UILabel* lab = [mc valueForKey: @"theLabel"];
    [self.window addSubview: lab]; 
    lab.center = CGPointMake(100,100);
    lab.frame = CGRectIntegral(lab.frame); // added to prevent fuzzies

    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc] init]; // silence warning
    [self.window makeKeyAndVisible];
    return YES;
}

@end
