

#import "Dog.h"


@implementation Dog

{
    int _number;
}


- (id) initWithNumber: (int) n {
    self = [super init];
    if (self) {
        self->_number = n;
    }
    return self;
}

- (id) init {
    return [self initWithNumber: -9999];
}

- (int) number {
    return self->_number;
}

@end
