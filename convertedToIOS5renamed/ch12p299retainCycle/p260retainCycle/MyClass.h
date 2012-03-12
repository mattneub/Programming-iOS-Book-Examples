

#import <Foundation/Foundation.h>

@interface MyClass : NSObject {
    @public 
    id thing; // make this __weak to prevent the retain cycle
}
@end
