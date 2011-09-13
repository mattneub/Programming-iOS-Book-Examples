

#import "Dog.h"


@implementation Dog

- (void) setNumber: (int) n {
    self->number = n;
}

- (int) number {
    return self->number;
}

@end
