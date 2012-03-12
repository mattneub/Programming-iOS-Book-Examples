
#import "AppDelegate.h"
#import "MyWindow.h"

// showing how to substitute your own window subclass in a storyboard application

@implementation AppDelegate

@synthesize window = _window;

- (UIWindow*) window {
    UIWindow* w = self->_window;
    if (!w) {
        NSLog(@"creating the window");
        w = [[MyWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self->_window = w;
    }
    return w;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							

@end
