

#import "HitTestingAppDelegate.h"

@implementation HitTestingAppDelegate

// tap a planet

@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UITapGestureRecognizer* t1 = [[UITapGestureRecognizer alloc] 
                                  initWithTarget:self 
                                  action:@selector(singleTap:)];
    [self.window addGestureRecognizer:t1];
    [t1 release];

    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) singleTap: (UIGestureRecognizer*) g {
    CGPoint p = [g locationOfTouch:0 inView:self.window];
    UIView* v = [self.window hitTest:p withEvent:nil];
    if (v && [v isKindOfClass:[UIImageView class]]) {
        [UIView animateWithDuration:0.2 
                              delay:0 
                            options:UIViewAnimationOptionAutoreverse 
                         animations:^(void) {
            v.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^ (BOOL b) {
            v.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
