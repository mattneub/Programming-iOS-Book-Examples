

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize v, window = _window;

// repeat animation a finite number of times by recursing
// should be safe if the number of times is small

- (void) animate: (int) count {
    CGPoint p = v.center;
    CGPoint pOrig = p;
    p.x += 100;
    void (^anim) (void) = ^{
        v.center = p;
    };
    void (^after) (BOOL) = ^(BOOL f) {
        v.center = pOrig;
        if (count)
            [self animate: count-1];
    };
    NSUInteger opts = UIViewAnimationOptionAutoreverse;
    [UIView animateWithDuration:1 delay:0 options:opts 
                     animations:anim completion:after];
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
    [self.window makeKeyAndVisible];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self animate:2]; // i.e. three times
    });
    
    return YES;
}



@end
