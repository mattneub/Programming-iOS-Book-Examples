

#import "AppDelegate.h"
#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    
//    MyView* mv = [[MyView alloc] 
//                  initWithFrame: CGRectMake(0, 0, self.window.bounds.size.width - 50, 150)];
//    mv.center = self.window.center;
    MyView* mv = [MyView new];
    [self.window.rootViewController.view addSubview: mv];
    mv.opaque = NO;
    
    mv.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray* cons;
    NSLayoutConstraint* con;
    cons = [NSLayoutConstraint
            constraintsWithVisualFormat:@"H:|-25-[v]-25-|"
            options:0 metrics:nil
            views:@{@"v":mv}];
    [mv.superview addConstraints:cons];
    cons = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:[v(150)]"
            options:0 metrics:nil
            views:@{@"v":mv}];
    [mv addConstraints:cons];
    // I don't think we can say this in the visual format language
    con = [NSLayoutConstraint
           constraintWithItem:mv
           attribute:NSLayoutAttributeCenterY
           relatedBy:NSLayoutRelationEqual
           toItem:mv.superview
           attribute:NSLayoutAttributeCenterY
           multiplier:1 constant:0];
    [mv.superview addConstraint:con];

    void (^resize) (void) = ^{
        CGRect f = mv.bounds;
        f.size.height *= 2;
        mv.bounds = f;
    };
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), resize);

    // NOTE: this is another way of doing the same thing, i.e. wait until after redraw moment
    // [CATransaction setCompletionBlock:resize];
    
    // NOTE: another way to see the effect could be to rotate the interface, thus changing our width
    // (if we have appropriate autoresizing or, as here, constraints)
    // this was always true (autoresizing is a bounds change and does not of itself cause redraw)
    // but it didn't occur to me in earlier editions to point this out
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}



@end
