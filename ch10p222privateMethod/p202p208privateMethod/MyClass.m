
#import "MyClass.h"

@interface MyClass (Tricky)
- (NSString*) myMethod; // myMethod is declared "privately"
@end

@implementation MyClass

- (NSString*) myMethod {
    return @"Howdy";
}

- (NSString*) publicMethod {
    return [self myMethod]; // legal
}


@end
