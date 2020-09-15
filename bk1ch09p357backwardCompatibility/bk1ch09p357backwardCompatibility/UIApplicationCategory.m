

#import "UIApplicationCategory.h"

@implementation UIApplication (MyCategory)

+ (BOOL) safeToUseSettingsString {
    return &UIApplicationOpenSettingsURLString != nil;
}

@end
