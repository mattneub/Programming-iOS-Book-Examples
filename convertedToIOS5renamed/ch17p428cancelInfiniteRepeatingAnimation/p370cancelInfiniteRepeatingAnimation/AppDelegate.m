

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize button, v, window = _window;

static CGPoint pOrig;

- (void) animate {
    CGPoint p = v.center;
    pOrig = p;
    p.x += 100;
    void (^anim) (void) = ^{
        self.button.enabled = YES;
        v.center = p;
    };
    void (^after) (BOOL) = ^(BOOL f) {
        v.center = pOrig;
    };
    NSUInteger opts = UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat;
    [UIView animateWithDuration:1 delay:0 options:opts 
                     animations:anim completion:after];
}

- (void) cancel {
    void (^anim) (void) = ^{
        self.button.enabled = NO;
        v.center = pOrig;
    };
    NSUInteger opts = UIViewAnimationOptionBeginFromCurrentState;
    [UIView animateWithDuration:.1 delay:0 options:opts 
                     animations:anim completion:nil];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.v = [[UIView alloc] initWithFrame:CGRectMake(58,255,204,204)];
    v.backgroundColor = [UIColor redColor];
    [self.window.rootViewController.view addSubview: v];
    UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b setTitle:@"Cancel" forState:UIControlStateNormal];
    [b sizeToFit];
    b.center = CGPointMake(100,30);
    b.frame = CGRectIntegral(b.frame);
    b.enabled = NO;
    [b addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.button = b;
    [self.window.rootViewController.view addSubview:b];
    [self.window makeKeyAndVisible];
    [self performSelector:@selector(animate) withObject:nil afterDelay:1.0];
    
    return YES;
}


@end
