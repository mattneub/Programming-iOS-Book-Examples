

#import "Dog.h"


@implementation Dog

{
    int _number;
}

- (void) setNumber: (int) n {
    self->_number = n;
}

- (int) number {
    return self->_number;
}

@end
