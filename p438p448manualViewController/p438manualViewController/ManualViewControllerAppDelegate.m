

#import "ManualViewControllerAppDelegate.h"
#import "RootViewController.h"

@implementation ManualViewControllerAppDelegate


@synthesize window=_window;
@synthesize rvc;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RootViewController* theRVC = [[RootViewController alloc] init];
    self.rvc = theRVC;
    [theRVC release];

    [self.window addSubview:self.rvc.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [rvc release];
    [_window release];
    [super dealloc];
}

@end
