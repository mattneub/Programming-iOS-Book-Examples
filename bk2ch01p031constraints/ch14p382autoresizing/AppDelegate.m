
#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [UIViewController new];
    UIView* mainview = self.window.rootViewController.view;
    
    
    UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(100, 111, 132, 194)];
    v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
    UIView* v2 = [UIView new];
    v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
    UIView* v3 = [UIView new];
    v3.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    [mainview addSubview: v1];
    [v1 addSubview: v2];
    [v1 addSubview: v3];
    

    v2.translatesAutoresizingMaskIntoConstraints = NO;
    v3.translatesAutoresizingMaskIntoConstraints = NO;
    
#define which 2 // and try "2", same result by visual format
    
#if which==1
    
    [v1 addConstraint:
     [NSLayoutConstraint
      constraintWithItem:v2 attribute:NSLayoutAttributeLeft
      relatedBy:0
      toItem:v1 attribute:NSLayoutAttributeLeft
      multiplier:1 constant:0]];
    [v1 addConstraint:
     [NSLayoutConstraint
      constraintWithItem:v2 attribute:NSLayoutAttributeRight
      relatedBy:0
      toItem:v1 attribute:NSLayoutAttributeRight
      multiplier:1 constant:0]];
    [v1 addConstraint:
     [NSLayoutConstraint
      constraintWithItem:v2 attribute:NSLayoutAttributeTop
      relatedBy:0
      toItem:v1 attribute:NSLayoutAttributeTop
      multiplier:1 constant:0]];
    [v2 addConstraint:
     [NSLayoutConstraint
      constraintWithItem:v2 attribute:NSLayoutAttributeHeight
      relatedBy:0
      toItem:nil attribute:0
      multiplier:1 constant:10]];
    [v3 addConstraint:
     [NSLayoutConstraint
      constraintWithItem:v3 attribute:NSLayoutAttributeWidth
      relatedBy:0
      toItem:nil attribute:0
      multiplier:1 constant:20]];
    [v3 addConstraint:
     [NSLayoutConstraint
      constraintWithItem:v3 attribute:NSLayoutAttributeHeight
      relatedBy:0
      toItem:nil attribute:0
      multiplier:1 constant:20]];
    [v1 addConstraint:
     [NSLayoutConstraint
      constraintWithItem:v3 attribute:NSLayoutAttributeRight
      relatedBy:0
      toItem:v1 attribute:NSLayoutAttributeRight
      multiplier:1 constant:0]];
    [v1 addConstraint:
     [NSLayoutConstraint
      constraintWithItem:v3 attribute:NSLayoutAttributeBottom
      relatedBy:0
      toItem:v1 attribute:NSLayoutAttributeBottom
      multiplier:1 constant:0]];

#elif which==2
    
    NSDictionary *vs = NSDictionaryOfVariableBindings(v2,v3);
    [v1 addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|[v2]|"
      options:0 metrics:nil views:vs]];
    [v1 addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|[v2(10)]"
      options:0 metrics:nil views:vs]];
    [v1 addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:[v3(20)]|"
      options:0 metrics:nil views:vs]];
    [v1 addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:[v3(20)]|"
      options:0 metrics:nil views:vs]];
    
#endif
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        CGRect r = v1.bounds;
        r.size.width += 40;
        r.size.height -= 50;
        v1.bounds = r;
    });
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
