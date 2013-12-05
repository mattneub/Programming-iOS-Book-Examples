

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.window.rootViewController = [UIViewController new];
    UIView* mainview = self.window.rootViewController.view;
    
#define which 1 // change "1" to "2" or "3" to generate the other figures
    
    switch (which) {
        case 1:
        {
            // figure 14-3
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(113, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:CGRectInset(v1.bounds, 10, 10)];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [mainview addSubview: v1];
            [v1 addSubview: v2];
            break;
        }
        case 2:
        {
            // figure 14-4
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(113, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:CGRectInset(v1.bounds, 10, 10)];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [mainview addSubview: v1];
            [v1 addSubview: v2];
            CGRect r = v2.bounds;
            r.size.height += 20;
            r.size.width += 20;
            v2.bounds = r;
            break;
        }
        case 3:
        {
            // figure 14-5
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(113, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:CGRectInset(v1.bounds, 10, 10)];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [mainview addSubview: v1];
            [v1 addSubview: v2];
            CGRect r = v1.bounds;
            r.origin.x += 10;
            r.origin.y += 10;
            v1.bounds = r;
            break;
        }
    }
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
