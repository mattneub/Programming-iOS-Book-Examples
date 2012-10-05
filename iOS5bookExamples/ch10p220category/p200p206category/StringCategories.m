
#import "StringCategories.h"


@implementation NSString (MyStringCategories)

- (NSString*) basePictureName {
    return [self stringByAppendingString:@"IO"];
}

@end