

#import "AppDelegate.h"
#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate

@synthesize window = _window;

- (void) resize: (id) dummy {
    UIView* mv = [self.window viewWithTag:111];
    CGRect f = mv.bounds;
    f.size.height *= 2;
    mv.bounds = f;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    
    MyView* mv = [[MyView alloc] 
                  initWithFrame: CGRectMake(0, 0, self.window.bounds.size.width - 50, 150)];
    mv.center = self.window.center;
    [self.window.rootViewController.view addSubview: mv];
    mv.opaque = NO;
    mv.tag = 111; // so I can get a reference to this view later

    [self performSelector:@selector(resize:) withObject:nil afterDelay:0.1];
    // NOTE: this is another way of doing the same thing, i.e. wait until after redraw moment
    // [CATransaction setCompletionBlock:^{[self resize:nil];}];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}



@end
