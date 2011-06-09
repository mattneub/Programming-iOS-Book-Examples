

#import "BoundsAppDelegate.h"

@implementation BoundsAppDelegate


@synthesize window=_window;

#define which 1 // change "1" to "2" or "3" to generate the other figures

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    switch (which) {
        case 1: 
        {
            // figure 14-3
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(113, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:CGRectInset(v1.bounds, 10, 10)];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [self.window addSubview: v1];
            [v1 addSubview: v2];
            [v1 release]; [v2 release];
            break;
        }
        case 2:
        {
            // figure 14-4
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(113, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:CGRectInset(v1.bounds, 10, 10)];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [self.window addSubview: v1];
            [v1 addSubview: v2];
            CGRect f = v2.bounds;
            f.size.height += 20;
            f.size.width += 20;
            v2.bounds = f;
            [v1 release]; [v2 release];
            break;
        }
        case 3:
        {
            // figure 14-5
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(113, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:CGRectInset(v1.bounds, 10, 10)];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [self.window addSubview: v1];
            [v1 addSubview: v2];
            CGRect f = v1.bounds;
            f.origin.x += 10;
            f.origin.y += 10;
            v1.bounds = f;
            [v1 release]; [v2 release];
            break;
        }
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
