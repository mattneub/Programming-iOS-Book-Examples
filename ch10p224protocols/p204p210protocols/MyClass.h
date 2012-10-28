

#import <Foundation/Foundation.h>

//@interface MyClass : NSObject <NSCopying> {
// uncomment the previous line, and comment out the next one, to get a different compiler warning
@interface MyClass : NSObject {
    
}

@end

/* Note that you can declare conformance using a class extension
 (in the implementation file)
 instead of in the interface file.
 I think I'll use that convention throughout from now on,
 since it makes it that much easier to see what's going on in one place.
*/