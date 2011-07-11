
#import "Person.h"


@implementation Person
@synthesize lastName, firstName;

- (void)dealloc {
    [firstName release];
    [lastName release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //[super encodeWithCoder: encoder];
    [encoder encodeObject:self->lastName forKey:@"last"];
    [encoder encodeObject:self->firstName forKey:@"first"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    //self = [super initWithCoder: decoder];
    self = [super init];
    self->lastName = [decoder decodeObjectForKey:@"last"];
    [self->lastName retain];
    self->firstName = [decoder decodeObjectForKey:@"first"];
    [self->firstName retain];
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat: @"%@ %@", firstName, lastName];
}

@end
