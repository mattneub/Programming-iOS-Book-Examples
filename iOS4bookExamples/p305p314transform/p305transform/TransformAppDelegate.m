

#import "TransformAppDelegate.h"

@implementation TransformAppDelegate


@synthesize window=_window;

# define which 1 // substitute "2" thru "7" to run other examples

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    switch (which) {
        case 1:
        {
            // figure 14-8
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(113, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:CGRectInset(v1.bounds, 10, 10)];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [self.window addSubview: v1];
            [v1 addSubview: v2];

            v1.transform = CGAffineTransformMakeRotation(45 * M_PI/180.0);
            
            [v1 release]; [v2 release];
            break;
        }
        case 2:
        {
            // figure 14-9
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(113, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:CGRectInset(v1.bounds, 10, 10)];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [self.window addSubview: v1];
            [v1 addSubview: v2];

            v1.transform = CGAffineTransformMakeScale(1.8, 1);
            
            [v1 release]; [v2 release];
            break;
        }
        case 3:
        {
            // figure 14-10
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(20, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:v1.bounds];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [self.window addSubview: v1];
            [v1 addSubview: v2];
            
            v2.transform = CGAffineTransformMakeTranslation(100, 0);
            v2.transform = CGAffineTransformRotate(v2.transform, 45 * M_PI/180.0);
            
            [v1 release]; [v2 release];
            break;
        }
        case 4:
        {
            // figure 14-11
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(20, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:v1.bounds];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [self.window addSubview: v1];
            [v1 addSubview: v2];
            
            v2.transform = CGAffineTransformMakeRotation(45 * M_PI/180.0);
            v2.transform = CGAffineTransformTranslate(v2.transform, 100, 0);
            
            [v1 release]; [v2 release];
            break;
        }
        case 5:
        {
            // figure 14-11 using concat
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(20, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:v1.bounds];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [self.window addSubview: v1];
            [v1 addSubview: v2];
            
            CGAffineTransform r = CGAffineTransformMakeRotation(45 * M_PI/180.0);
            CGAffineTransform t = CGAffineTransformMakeTranslation(100, 0);
            v2.transform = CGAffineTransformConcat(t,r); // not r,t
            
            [v1 release]; [v2 release];
            break;
        }
        case 6:
        {
            // figure 14-12
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(20, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:v1.bounds];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [self.window addSubview: v1];
            [v1 addSubview: v2];
            
            CGAffineTransform r = CGAffineTransformMakeRotation(45 * M_PI/180.0);
            CGAffineTransform t = CGAffineTransformMakeTranslation(100, 0);
            v2.transform = CGAffineTransformConcat(t,r);
            v2.transform = CGAffineTransformConcat(CGAffineTransformInvert(r), v2.transform);
            
            [v1 release]; [v2 release];
            break;
        }
        case 7:
        {
            // figure 14-13
            UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(113, 111, 132, 194)];
            v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
            UIView* v2 = [[UIView alloc] initWithFrame:CGRectInset(v1.bounds, 10, 10)];
            v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
            [self.window addSubview: v1];
            [v1 addSubview: v2];
            
            v1.transform = CGAffineTransformMake(1, 0, -0.2, 1, 0, 0);
            
            [v1 release]; [v2 release];
            break;
        }
    }

    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
