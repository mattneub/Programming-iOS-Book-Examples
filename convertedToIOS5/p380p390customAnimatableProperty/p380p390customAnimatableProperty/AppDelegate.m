
#import "AppDelegate.h"
#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize v;

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
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.v = [[MyView alloc] initWithFrame:CGRectMake(51,40,218,177)];
    self.v.opaque = NO;
    self.v.backgroundColor = [UIColor clearColor];
    [self.window addSubview: self.v];
    [self.window makeKeyAndVisible];
    [self performSelector:@selector(animate) withObject:nil afterDelay:1.0];
    return YES;
}

@end
