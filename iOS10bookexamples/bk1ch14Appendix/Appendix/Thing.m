

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

@end

@implementation Thing2

- (void) giveMeAThing:(nonnull id)anObject {
    
}

@end

