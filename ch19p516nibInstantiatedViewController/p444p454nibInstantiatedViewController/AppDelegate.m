

#import "AppDelegate.h"

@implementation AppDelegate {
    
    IBOutlet UIViewController *vc;
    
}



#define which 1 // try also "2"


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    // this style of view controller instantiation is a little trickier to illustrate
    // than it was in earlier versions of Xcode, because no built-in template
    // uses the automatically loaded main nib
    // so we manually load a nib which instantiates a view controller...
    // ...and manually assign it as the window's root view controller
    
    switch (which) {
        case 1:
        {
            // the view controller's view is drawn directly in the same nib (MyNib)
            [[NSBundle mainBundle] loadNibNamed:@"MyNib" owner:self options:nil];
            self.window.rootViewController = self->vc;
            break;
        }
        case 2:
        {
            // the view controller's view is loaded automatically from a different nib (RootView)
            [[NSBundle mainBundle] loadNibNamed:@"MyNib2" owner:self options:nil];
            self.window.rootViewController = self->vc;
            break;
        }
    }
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
