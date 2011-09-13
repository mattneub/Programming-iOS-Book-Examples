

#import "Dog.h"


@implementation Dog

- (id) initWithNumber: (int) n {
    self = [super init];
    if (self) {
        self->number = n;
    }
    return self;
}

- (id) init {
    return [self initWithNumber: -9999];
}

- (int) number {
    return self->number;
}

@end
