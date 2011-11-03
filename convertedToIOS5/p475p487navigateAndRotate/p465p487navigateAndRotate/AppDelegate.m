

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // it's a pity that none of the templates now illustrate loading a nav controller from nib
    // you can configure a nav controller very heavily in a nib,
    // so this is a nice technique for reducing code
    [[NSBundle mainBundle] loadNibNamed:@"NavController" owner:self options:nil];
    // (could use storyboard instead, of course)
    

    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
