

#import <Foundation/Foundation.h>


@interface Dog : NSObject {
    NSString* name; // could comment this out, implicit ivar
}

- (id) initWithName: (NSString*) s;
@property (nonatomic, copy) NSString* name;

@end
