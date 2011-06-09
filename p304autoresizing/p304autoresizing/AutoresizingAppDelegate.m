

#import "AutoresizingAppDelegate.h"

@implementation AutoresizingAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // figure 14-6
    UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(100, 111, 132, 194)];
    v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
    UIView* v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 132, 10)];
    v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
    UIView* v3 = 
    [[UIView alloc] initWithFrame:CGRectMake(v1.bounds.size.width-20, 
                                             v1.bounds.size.height-20, 
                                             20, 20)];
    v3.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    [self.window addSubview: v1];
    [v1 addSubview: v2];
    [v1 addSubview: v3];

    v2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    v3.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;

    // uncomment these next lines, to see the result of autoresizing (figure 14-7)
    
//    CGRect f = v1.bounds;
//    f.size.width += 40;
//    f.size.height -= 50;
//    v1.bounds = f;

    
    
    [v1 release]; [v2 release]; [v3 release];

    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
