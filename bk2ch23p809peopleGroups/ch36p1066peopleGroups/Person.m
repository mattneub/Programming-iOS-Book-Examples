

#import "Person.h"


@implementation Person


- (void)encodeWithCoder:(NSCoder *)encoder {
    //[super encodeWithCoder: encoder]; // not in this case
    [encoder encodeObject:self.lastName forKey:@"last"];
    [encoder encodeObject:self.firstName forKey:@"first"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    //self = [super initWithCoder: decoder]; // not in this case
    self = [super init];
    self->_lastName = [decoder decodeObjectForKey:@"last"];
    self->_firstName = [decoder decodeObjectForKey:@"first"];
    return self;
}


@end
