

#import <Foundation/Foundation.h>

@interface MyClass : NSObject {
    @public 
    /* __weak */ id thing; // make this __weak to prevent the retain cycle
}
@end
