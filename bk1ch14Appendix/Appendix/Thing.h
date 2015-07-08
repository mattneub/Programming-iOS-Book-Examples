

#import <Foundation/Foundation.h>

enum state {
    kDead,
    kAlive
};

void setState (enum state s);

@interface Thing : NSObject

NS_ASSUME_NONNULL_BEGIN
- (NSString*) badMethod: (NSString*) s;
- (nullable NSString*) goodMethod: (NSString*) s;
- (NSArray<NSString*>*) pepBoys;
NS_ASSUME_NONNULL_END

@end
