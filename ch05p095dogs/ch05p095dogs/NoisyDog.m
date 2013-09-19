

#import "NoisyDog.h"


@implementation NoisyDog

- (NSString*) bark {
    return [NSString stringWithFormat: @"%@ %@", [super bark], [super bark]];
}

@end
