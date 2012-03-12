

#import "Dog.h"


@implementation Dog
@synthesize name;

// complete memory management of an ivar, synthesized accessors
// this example is not exactly in the book, but it makes a nice follow-on from the previous example

- (id) initWithName: (NSString*) s { 
    self = [super init]; 
    if (self) {
        self->name = [s copy];
    }
    return self;
}

- (id) init {
    NSAssert(NO, @"Making a nameless dog is forbidden.");
    return nil;
}

// no dealloc needed under ARC

@end
