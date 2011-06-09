

#import "Empty_WindowAppDelegate.h"

@implementation Empty_WindowAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
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
    // memory management (even though we won't discuss this until Chapter 12)
    [av release];
}




- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
