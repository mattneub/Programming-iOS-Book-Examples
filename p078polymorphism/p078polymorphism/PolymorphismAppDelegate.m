

#import "PolymorphismAppDelegate.h"

@implementation PolymorphismAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // we can assign a UIButton to a UIView because a UIButton *is* a UIView
    UIView* v = b;
    // we can send a UIButton message to a UIView, but we must typecast to quiet the compiler
    // this works at runtime because is UIView really *is* a UIButton
    [(UIButton*)v setTitle:@"Howdy!" forState:UIControlStateNormal];
    // we can send a UIView message to a UIButton because a UIButton *is* a UIView
    [b setFrame: CGRectMake(100,100,100,35)];
    
    
    // just to prove that it all worked, I'll put the button into the interface
    [self.window addSubview:b];
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
