

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = [UIViewController new];
    
    UIButton* b = [UIButton buttonWithType:UIButtonTypeSystem];
    // we can assign a UIButton to a UIView because a UIButton *is* a UIView
    UIView* v = b;
    // we can send a UIButton message to a UIView, but we must typecast to quiet the compiler
    // this works at runtime because is UIView really *is* a UIButton
    [(UIButton*)v setTitle:@"Howdy!" forState:UIControlStateNormal];
    // we can send a UIView message to a UIButton because a UIButton *is* a UIView
    [b setFrame: CGRectMake(100,100,52,30)];
    
    // just to prove that it all worked, I'll put the button into the interface
    [self.window.rootViewController.view addSubview:b];
    
    
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
