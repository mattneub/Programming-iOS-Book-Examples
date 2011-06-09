

#import <Foundation/Foundation.h>


@interface Dog : NSObject {
    NSString* name;
}
- (id) initWithName: (NSString*) s;
- (NSString*) name;
// - (void) setName: (NSString*) s;
@end
