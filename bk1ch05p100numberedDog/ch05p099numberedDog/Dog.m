

#import "Dog.h"


@implementation Dog

{
    int number;
}

- (void) setNumber: (int) n {
    self->number = n;
}

- (int) number {
    return self->number;
}



@end
