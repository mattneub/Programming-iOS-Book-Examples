

#import "Dog.h"


@implementation Dog

// autosynthesis, ivar is called _name

- (id) initWithName: (NSString*) s { 
    self = [super init]; 
    if (self) {
        self->_name = [s copy];
    }
    return self;
}

- (id) init {
    NSAssert(NO, @"Making a nameless dog is forbidden.");
    return nil;
}

@end
