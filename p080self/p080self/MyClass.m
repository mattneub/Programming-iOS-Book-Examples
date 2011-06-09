
#import "MyClass.h"


@implementation MyClass

- (NSString*) greeting {
    return @"Good night, Gracie!";
}

- (NSString*) sayGoodnightGracie {
    return [self greeting];
}

@end
