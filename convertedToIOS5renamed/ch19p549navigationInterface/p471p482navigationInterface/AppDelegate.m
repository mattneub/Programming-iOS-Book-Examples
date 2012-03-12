

#import "AppDelegate.h"
#import "View1Controller.h"
#import "View2Controller.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    View1Controller* v1c = [[View1Controller alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:v1c];
        
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    
    
    // May as well go nuts with the new iOS 5 wild and crazy colorizations...
    // Comment out next line and away we go
    return YES;
    
    nav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor redColor],
                                             UITextAttributeTextColor,
                                             [UIFont fontWithName:@"Bradley Hand" size:30],
                                             UITextAttributeFont,
                                             nil];
    // adjust upwards (notice that negative is up)
    [nav.navigationBar setTitleVerticalPositionAdjustment:-5.0 forBarMetrics:UIBarMetricsDefault];
    // the purpose of the "bar metrics" is that you might want something different...
    // in landscape on the phone, where the bar is narrower
    nav.navigationBar.tintColor = [UIColor orangeColor];

    // we'll use the appearance proxy to set tab bar item features throughout the app
    // note: appearance is an id, so if you get a method name wrong, you don't find out...
    // ...until the app crashes
    [[UIBarButtonItem appearance]
     setTintColor:[UIColor redColor]];


    [[UIBarButtonItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor],
      UITextAttributeTextColor,
      nil] 
                                                forState:UIControlStateNormal];
    
    UIImage* im = [UIImage imageNamed:@"linen.png"];
    CGSize sz = CGSizeMake(24,24);
    UIGraphicsBeginImageContext(sz);
    [im drawInRect:(CGRect){CGPointZero, sz}];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    im2 = [im2 resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:im2 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    return YES;
}

@end
