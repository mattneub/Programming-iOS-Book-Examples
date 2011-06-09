

#import "CustomAnimatablePropertyAppDelegate.h"
#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomAnimatablePropertyAppDelegate


@synthesize window=_window;
@synthesize v = _v;

- (void) animate {
    CALayer* lay = self.v.layer;
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"thickness"];
    ba.toValue = [NSNumber numberWithFloat: 10.0];
    ba.autoreverses = YES;
    [lay addAnimation:ba forKey:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self performSelector:@selector(animate) withObject:nil afterDelay:1.0];
    // Override point for customization after application launch.
    [self.v.layer setNeedsDisplay];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [_v release];
    [super dealloc];
}

@end
