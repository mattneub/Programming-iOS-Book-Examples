
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TestEnum) {
    TestEnumOne = 1,
    TestEnumTwo,
//    TestEnumThree, // uncomment to see warning
};

NS_ASSUME_NONNULL_BEGIN

@interface Thing : NSObject

@end

NS_ASSUME_NONNULL_END
