

#import "AppDelegate.h"

@implementation AppDelegate

{
    IBOutlet UIButton* theButton;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UIViewController alloc] init]; //
    
    // Override point for customization after application launch.
    
    // Load nib, much as before, except that we're not bothering with any extra class:
    // we use self as owner
    // we have an ivar corresponding to the outlet so we can grab the button from the nib
    // we there is also an action in the nib from the button to our buttonPressed:
    
    [[NSBundle mainBundle] loadNibNamed:@"MyNib" owner:self options:nil]; 
    [self.window.rootViewController.view addSubview: self->theButton]; //
    self->theButton.center = CGPointMake(100,100);
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (IBAction) buttonPressed: (id) sender {
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Howdy!"
                                                 message:@"You tapped me." 
                                                delegate:nil 
                                       cancelButtonTitle:@"Cool"
                                       otherButtonTitles:nil];
    [av show];
}

@end
