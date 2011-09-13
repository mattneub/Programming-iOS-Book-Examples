

#import <Foundation/Foundation.h>


@interface Dog : NSObject {
}

- (id) initWithName: (NSString*) s;
@property (nonatomic, readonly, copy) NSString* name;

@end
