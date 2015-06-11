
#import <UIKit/UIKit.h>
@import CoreText;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

@interface UIFont (CTFont)
- (CTFontRef) toCTFont;
+ (UIFont*) fromCTFont: (CTFontRef) ctfont;
@end
