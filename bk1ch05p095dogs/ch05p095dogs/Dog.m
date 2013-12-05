

#import "Dog.h"


@implementation Dog

- (NSString*) bark { 
    return @"Woof!";
} 

- (NSString*) speak {
    return [self bark];
}

@end
