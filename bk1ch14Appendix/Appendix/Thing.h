

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

- (void) combineWithThing: (Thing*) otherThing;
// generated interface is: public func combine(with otherThing: Thing)
// thus showing that we get renamification on our own methods

NS_ASSUME_NONNULL_END


@end
