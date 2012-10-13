

#import "AppDelegate.h"

@interface AppDelegate ()
@property (strong, nonatomic) UIView* v;
@property (strong, nonatomic) UIButton* button;
@end

@implementation AppDelegate

static CGPoint pOrig;

- (void) animate {
    CGPoint p = _v.center;
    pOrig = p;
    p.x += 100;
    void (^anim) (void) = ^{
        _button.enabled = YES;
        _v.center = p;
    };
    void (^after) (BOOL) = ^(BOOL f) {
        _v.center = pOrig;
    };
    NSUInteger opts = UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat;
    [UIView animateWithDuration:1 delay:0 options:opts 
                     animations:anim completion:after];
}

- (void) cancel {
    void (^anim) (void) = ^{
        _button.enabled = NO;
        _v.center = pOrig;
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
    _v.backgroundColor = [UIColor redColor];
    [self.window.rootViewController.view addSubview: _v];
    UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b setTitle:@"Cancel" forState:UIControlStateNormal];
    [b sizeToFit];
    b.center = CGPointMake(100,30);
    b.frame = CGRectIntegral(b.frame);
    b.enabled = NO;
    [b addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    _button = b;
    [self.window.rootViewController.view addSubview:b];
    [self.window makeKeyAndVisible];
    [self performSelector:@selector(animate) withObject:nil afterDelay:1.0];
    
    return YES;
}


@end
