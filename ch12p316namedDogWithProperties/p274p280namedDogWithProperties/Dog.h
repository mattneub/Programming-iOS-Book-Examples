

#import <Foundation/Foundation.h>


@interface Dog : NSObject {
    NSString* name; // could comment this out, implicit ivar
                    // (but note that then it wouldn't show up when debugging)
}

- (id) initWithName: (NSString*) s;
@property (nonatomic, copy) NSString* name;

@end
