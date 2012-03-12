

#import <Foundation/Foundation.h>


@interface Dog : NSObject {
}

- (id) initWithName: (NSString*) s;
- (void) dummy;
@property (nonatomic, readonly, copy) NSString* name;

@end
