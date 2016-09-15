

#import <Foundation/Foundation.h>

enum State {
    kDead,
    kAlive
};
typedef enum State State;

void setState (State s);

@interface Thing : NSObject

NS_ASSUME_NONNULL_BEGIN
- (NSString*) badMethod: (NSString*) s;
- (nullable NSString*) goodMethod: (NSString*) s;
- (NSArray<NSString*>*) pepBoys;
NS_ASSUME_NONNULL_END

@end
