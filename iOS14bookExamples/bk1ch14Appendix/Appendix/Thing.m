

#import "Thing.h"
#import "Appendix-Swift.h"
#import <CoreLocation/CoreLocation.h>

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
    WombleNSObject* womble = [[WombleNSObject alloc] init];
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

- (NSString*) stringReturnerWithError: (NSError**) err {
    return nil; // proving that this is all it takes to throw; we don't actually have to supply NSError
    return @"howdy";
}

- (BOOL) boolReturnerWithError: (NSError**) err {
    // we don't actually have to supply NSError here either
    // here, let's throw a core location error to see how it comes across in Swift
    *err = [[NSError alloc] initWithDomain:kCLErrorDomain code:kCLErrorLocationUnknown userInfo:nil];
    return NO; // proving the this is all it takes to throw
    return YES;
}

@end

@implementation Thing2

- (void) giveMeAThing:(nonnull id)anObject {
    
}

@end

