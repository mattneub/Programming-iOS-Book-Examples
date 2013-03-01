

#import "AppDelegate.h"

@implementation AppDelegate

#define which 1 // and try 2 and 3 to use iOS 6 constraints instead

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    
    // figure 14-12
    UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(100, 111, 132, 194)];
    v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
    
    UIView* v2;
    UIView* v3;
    
    switch (which) {
        
        case 1: { // the old way, you provide a frame plus autoresizing as needed
            v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 132, 10)];
            v3 = [[UIView alloc] initWithFrame:CGRectMake(v1.bounds.size.width-20,
                                                          v1.bounds.size.height-20,
                                                          20, 20)];
            break;
        }
        
        case 2: case 3:
        { // but if you're going to use constraints, supplying a frame is pointless!
            // both dimensions and positioning will be part of the constraints
            v2 = [UIView new];
            v3 = [UIView new];
            break;
        }
    }
    
    v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
    v3.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    [self.window.rootViewController.view addSubview: v1];
    [v1 addSubview: v2];
    [v1 addSubview: v3];
        
    switch (which) {
        case 1: { // the autoresizing way
            v2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            v3.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            break;
        }
        case 2: {
            //v1.translatesAutoresizingMaskIntoConstraints = NO;
            v2.translatesAutoresizingMaskIntoConstraints = NO;
            v3.translatesAutoresizingMaskIntoConstraints = NO;
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
            break;
        }
        case 3: {
            NSDictionary *vs = NSDictionaryOfVariableBindings(v2,v3);
            v2.translatesAutoresizingMaskIntoConstraints = NO;
            v3.translatesAutoresizingMaskIntoConstraints = NO;
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
            break;
        }
    }
    
    /* I just want to stress the importance of what we just did with constraints:
     they are a good way to assign a frame even if layout won't change!
     notice how I didn't have to do any math; I just said where they go in relation to superview
     so this would be a valuable technique even without these next upcoming lines
     */
    
    // these next lines show the result of autoresizing (figure 14-13)
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        CGRect f = v1.bounds;
        f.size.width += 40;
        f.size.height -= 50;
        v1.bounds = f;
//        NSLog(@"%@", v1.constraints);
//        NSLog(@"%i", v1.hasAmbiguousLayout);
//        NSLog(@"%i", v2.hasAmbiguousLayout);
//        NSLog(@"%i", v3.hasAmbiguousLayout);
    });
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
