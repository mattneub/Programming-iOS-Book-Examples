

#import "Dog.h"


@implementation Dog

// complete memory management of an ivar, synthesized accessors
// this example is not exactly in the book, but it makes a nice follow-on from the previous example
// really should add it now, as it is useful to illustrate authosynthesis formally

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

// no dealloc needed under ARC

@end
