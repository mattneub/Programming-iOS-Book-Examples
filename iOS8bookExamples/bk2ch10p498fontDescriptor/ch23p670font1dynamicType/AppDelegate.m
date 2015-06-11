

#import "AppDelegate.h"
@import CoreText;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							

@end

// not used; I just double-cast through AnyObject instead

@implementation UIFont (CTFont)
- (CTFontRef) toCTFont {
    return (__bridge CTFontRef) self;
}
+ (UIFont*) fromCTFont: (CTFontRef) ctfont {
    return (__bridge UIFont*) ctfont;
}
@end
