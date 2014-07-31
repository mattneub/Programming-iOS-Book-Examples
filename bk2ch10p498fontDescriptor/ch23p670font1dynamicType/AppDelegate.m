

#import "AppDelegate.h"
@import CoreText;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							

@end

@implementation UIFont (CTFont)
- (CTFontRef) toCTFont {
    return (__bridge CTFontRef) self;
}
+ (UIFont*) fromCTFont: (CTFontRef) ctfont {
    return (__bridge UIFont*)ctfont;
}
@end
