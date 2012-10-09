
#import "MyClass.h"

/* This example used to include this code:

@interface MyClass (Tricky)
- (NSString*) myMethod; // myMethod is declared "privately"
@end
 
 However, that's not necesary any more in order to declare privately.
 Why would you declare privately in a category? So that a method can see a method defined later.
 But in Xcode 4.4 and later, a method *can* see a method defined later!
 Thus, the definition *is* the private declaration.
 
 */

@implementation MyClass


- (NSString*) publicMethod {
    return [self myMethod]; // legal
    // in iOS 6, we can see a later method
}

- (NSString*) myMethod {
    return @"Howdy";
}



@end
