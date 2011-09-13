

#import "FrameAppDelegate.h"

@implementation FrameAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // generate figure 14-1
    UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(113, 111, 132, 194)];
    v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
    UIView* v2 = [[UIView alloc] initWithFrame:CGRectMake(41, 56, 132, 194)];
    v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
    UIView* v3 = [[UIView alloc] initWithFrame:CGRectMake(43, 197, 160, 230)];
    v3.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    [self.window addSubview: v1];
    [v1 addSubview: v2];
    [self.window addSubview: v3];
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
