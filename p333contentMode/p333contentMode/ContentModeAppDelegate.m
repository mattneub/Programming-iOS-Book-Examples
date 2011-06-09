

#import "ContentModeAppDelegate.h"
#import "MyView.h"

@implementation ContentModeAppDelegate


@synthesize window=_window;

// figure 15-10, resize view after it has been drawn, without forcing another redraw

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    MyView* mv = [[MyView alloc] 
                  initWithFrame: CGRectMake(0, 0, self.window.bounds.size.width - 50, 150)];
    mv.center = self.window.center;
    [self.window addSubview: mv];
    mv.opaque = NO;
    mv.tag = 111; // so I can get a reference to this view later
    [mv release];
    [self.window makeKeyAndVisible];
    [self performSelector:@selector(resize:) withObject:nil afterDelay:0.1];
    return YES;
}

- (void) resize: (id) dummy {
    UIView* mv = [self.window viewWithTag:111];
    CGRect f = mv.bounds;
    f.size.height *= 2;
    mv.bounds = f;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}


@end
