
#import "AppDelegate.h"
#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@interface AppDelegate ()
@property (strong, nonatomic) MyView *v;
@end

@implementation AppDelegate

@synthesize window = _window;

- (void) animate {
    CALayer* lay = self.v.layer;
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"thickness"];
    ba.toValue = [NSNumber numberWithFloat: 10.0];
    ba.autoreverses = YES;
    [lay addAnimation:ba forKey:nil];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.v = [[MyView alloc] initWithFrame:CGRectMake(51,40,218,177)];
    self.v.opaque = NO;
    self.v.backgroundColor = [UIColor clearColor];
    [self.window.rootViewController.view addSubview: self.v];
    UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b setTitle:@"Animate" forState:UIControlStateNormal];
    [b sizeToFit];
    b.center = CGPointMake(self.window.rootViewController.view.center.x,300);
    b.frame = CGRectIntegral(b.frame);
    [b addTarget:self action:@selector(animate) forControlEvents:UIControlEventTouchUpInside];
    [self.window.rootViewController.view addSubview:b];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
