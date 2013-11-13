
#import "Person.h"


@implementation Person


- (void)encodeWithCoder:(NSCoder *)encoder {
    //[super encodeWithCoder: encoder];
    [encoder encodeObject:self.lastName forKey:@"last"];
    [encoder encodeObject:self.firstName forKey:@"first"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    //self = [super initWithCoder: decoder];
    self = [super init];
    self->_lastName = [decoder decodeObjectForKey:@"last"];
    self->_firstName = [decoder decodeObjectForKey:@"first"];
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat: @"%@ %@", self.firstName, self.lastName];
}

@end
