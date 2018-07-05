

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
- (NSArray*) pepBoysBad;

- (void) combineWithThing: (Thing*) otherThing;
// generated interface is: open func combine(with otherThing: Thing)
// thus showing that we get renamification on our own methods

- (void) triumphOverThing: (Thing*) otherThing NS_SWIFT_NAME(triumph(over:));
// would be open func triumphOverThing(_ otherThing: Thing)
// we've made it open func triumph(over otherThing: Thing)

- (void) take1Bool: (BOOL) yn;
- (void) take1Number: (NSNumber*) n;
- (void) take1Value: (NSValue*) v;
- (void) take1Array: (NSArray*) arr;
- (void) take1id: (id) anid;
- (void) take1id2: (id) anid;

NS_ASSUME_NONNULL_END


@end

// showing that lightweight generics are imported as generics

@interface Thing2<ObjectType> : NSObject

- (void) giveMeAThing:(nonnull ObjectType)anObject;

@end
