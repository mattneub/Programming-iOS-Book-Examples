

#import "Dog.h"


@implementation Dog

{
    NSString* _name;
}


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

- (NSString*) name {
    return self->_name;
}

//- (void) setName: (NSString*) s {
//    if (self->_name != s) {
//        self->_name = [s copy];
//    }
//}


@end
