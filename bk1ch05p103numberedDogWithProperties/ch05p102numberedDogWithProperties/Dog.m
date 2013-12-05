

#import "Dog.h"


@implementation Dog

{
    int _number; // more usual convention nowadays, start ivar name with underscore
}

- (void) setNumber: (int) n {
    self->_number = n;
}

- (int) number {
    return self->_number;
}

@end
