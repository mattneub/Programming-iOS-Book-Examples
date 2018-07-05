

#import "Thing.h"
#import "Appendix-Swift.h"

void setState (State s) {
    NSLog(@"%d",s);
}


@implementation Thing

- (NSString*) badMethod: (NSString*) s {
    return @"howdy";
}

- (nullable NSString*) goodMethod: (NSString*) s {
    return @"howdy";
}

- (NSArray<NSString*>*) pepBoys {
    return @[@"Manny", @"Moe", @"Jack"];
}

- (NSArray*) pepBoysBad {
    return @[@"Manny", @"Moe", @"Jack"];
}

- (void) justTesting {
    Womble* womble = [[Womble alloc] init];
    womble = womble; // silence compiler
}

- (void) combineWithThing: (Thing*) otherThing {
    
}

- (void) triumphOverThing: (Thing*) otherThing {

}


- (void) take1Bool: (BOOL) yn {
    NSLog(@"%d", yn);
}

- (void) take1Number: (NSNumber*) n {
    NSLog(@"%@", n);
}

- (void) take1Value: (NSValue*) v {
    NSLog(@"%@", v);
}

- (void) take1Array: (NSArray*) arr {
    NSLog(@"%@", arr);
    for (id e in arr) {
        NSLog(@"%@: %@", NSStringFromClass([e class]), e);
    }
}

- (void) take1id: (id) anid {
    NSLog(@"%@: %@", NSStringFromClass([anid class]), anid);
}

- (void) take1id2: (id) anid {
    NSLog(@"%@: %@", NSStringFromClass([anid class]), @"cannot NSLog directly");
}


@end

@implementation Thing2

- (void) giveMeAThing:(nonnull id)anObject {
    
}

@end

