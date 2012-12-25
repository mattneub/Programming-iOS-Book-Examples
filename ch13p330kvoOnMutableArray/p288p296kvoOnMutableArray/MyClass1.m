

#import "MyClass1.h"


@implementation MyClass1

- (id)init {
    self = [super init];
    if (self) {
        NSMutableArray* marr = [NSMutableArray array];
        NSDictionary* d;
        d = @{
            @"name" : @"Manny",
            @"description" : @"The one with glasses."
        };
        [marr addObject:d];
        d = @{
            @"name" : @"Moe",
            @"description" : @"Looks a little like Governor Dewey."
        };
        [marr addObject:d];
        d = @{
            @"name" : @"Jack",
            @"description" : @"The one without a mustache."
        };
        [marr addObject:d];
        NSLog(@"%@",marr);
        self->_theData = marr;
    }
    return self;
}

- (NSMutableArray*) theDataGetter { 
    return [self mutableArrayValueForKey:@"theData"];
}

- (NSUInteger) countOfTheData {
    return [self->_theData count];
}

- (id) objectInTheDataAtIndex: (NSUInteger) ix {
    return self->_theData[ix];
}

- (void) insertObject: (id) val inTheDataAtIndex: (NSUInteger) ix {
    [self->_theData insertObject:val atIndex:ix];
}

- (void) removeObjectFromTheDataAtIndex: (NSUInteger) ix {
    [self->_theData removeObjectAtIndex: ix];
}


@end
