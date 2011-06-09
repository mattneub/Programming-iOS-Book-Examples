

#import "DrawingInNSViewAppDelegate.h"
#import "MyView.h"

@implementation DrawingInNSViewAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    MyView* mv = [[MyView alloc] initWithFrame: 
                  CGRectMake(0, 0, self.window.bounds.size.width - 50, 150)];
    mv.center = self.window.center;
    [self.window addSubview: mv];
    mv.opaque = NO;
    [mv release];

    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
