

#import "Dog.h"


@implementation Dog

// complete memory management of an ivar, hand-written accessors
// uncomment setName stuff if you want a dog whose name can be changed on the fly

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

- (NSString*) name {
    return self->name;
}

//- (void) setName: (NSString*) s {
//    if (self->name != s) {
//        [self->name release];
//        self->name = [s copy];
//    }
//}

- (void)dealloc {
    [self->name release];
    [super dealloc];
}

@end
