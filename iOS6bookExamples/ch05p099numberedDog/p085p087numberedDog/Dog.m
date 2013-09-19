

#import "Dog.h"


@implementation Dog

{ // ivars can now be declared in implementation section
    int number;
}

- (void) setNumber: (int) n {
    self->number = n;
}

- (int) number {
    return self->number;
}



@end
