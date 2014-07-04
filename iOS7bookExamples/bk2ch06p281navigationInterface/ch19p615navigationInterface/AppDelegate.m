

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // a few unnecessary appearance customizations (aka descent into total hideousness)
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [UIColor blackColor]}
                                                forState:UIControlStateNormal];
    
    UIImage* im = [UIImage imageNamed:@"linen.png"];
    CGSize sz = CGSizeMake(5,34);
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [im drawAtPoint:CGPointMake(-55,-55)];
    UIImage* im2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    im2 = [im2 resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0) resizingMode:UIImageResizingModeTile];
    [(UIBarButtonItem*)[UIBarButtonItem appearance] setBackgroundImage:im2 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    // if the back button is assigned a background image, the chevron is removed entirely
    // [(UIBarButtonItem*)[UIBarButtonItem appearance] setBackButtonBackgroundImage:im2 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // also, note that if the back button is assigned a background image it is not vertically resized
    // and if it has an image, that image is resized to fit

    return YES;
}
							

@end
