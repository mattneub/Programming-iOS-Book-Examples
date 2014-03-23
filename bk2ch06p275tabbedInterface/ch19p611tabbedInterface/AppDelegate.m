

#import "AppDelegate.h"

@interface AppDelegate() 
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // self.window.tintColor = [UIColor redColor]; // prove that bar item tint color is inherited
    
    [(UITabBarItem*)[UITabBarItem appearance]
     setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Heavy" size:14]} forState:UIControlStateNormal];
    
    UIFont* ding = [UIFont fontWithName:@"Zapf Dingbats" size:40];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,40), NO, 0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [UIColor redColor].CGColor);
    NSString* s = @"\u2713";
    NSMutableParagraphStyle* p = [NSMutableParagraphStyle new];
    p.alignment = NSTextAlignmentRight;
    [s drawInRect:CGRectMake(0,0,100,40) withAttributes:@{NSFontAttributeName:ding, NSParagraphStyleAttributeName:p}];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [(UITabBar*)[UITabBar appearance] setSelectionIndicatorImage:im];
        
    return YES;
}

							

@end
