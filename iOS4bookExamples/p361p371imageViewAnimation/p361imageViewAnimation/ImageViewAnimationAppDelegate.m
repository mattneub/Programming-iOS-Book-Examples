
#import "ImageViewAnimationAppDelegate.h"

@implementation ImageViewAnimationAppDelegate


@synthesize window=_window;
@synthesize iv;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self performSelector:@selector(animate) withObject:nil afterDelay:1.0];
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) animate {
    UIImage* mars = [UIImage imageNamed: @"mars.png"];
    UIGraphicsBeginImageContext(mars.size);
    UIImage* empty = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSArray* arr = [NSArray arrayWithObjects: mars, empty, mars, empty, mars, nil];
    iv.animationImages = arr;
    iv.animationDuration = 2;
    iv.animationRepeatCount = 1;
    [iv startAnimating];
}

- (void)dealloc
{
    [_window release];
    [iv release];
    [super dealloc];
}

@end
