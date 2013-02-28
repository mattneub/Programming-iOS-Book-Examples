

#import "Dog.h"


@implementation Dog

// complete memory management of an ivar, hand-written accessors
// uncomment setName stuff if you want a dog whose name can be changed on the fly

// this example is almost too easy under ARC! 
// however, it is still useful for showing init, and what hand-written accessors might look like

{
    NSString* _name; // strong by default
    // NB: rewrote ivar name with underscore, to match new convention
}


- (id) initWithName: (NSString*) s { 
    self = [super init]; 
    if (self) {
        self->_name = [s copy]; //
    }
    return self;
}

- (id) init {
    NSAssert(NO, @"Making a nameless dog is forbidden.");
    return nil;
}

- (NSString*) name {
    return self->_name; //
}

//- (void) setName: (NSString*) s {
//    if (self->_name != s) {
//        self->_name = [s copy];
//    }
//}


@end
