

#import "MyClass1.h"


@implementation MyClass1
@synthesize theData;

- (id)init {
    self = [super init];
    if (self) {
        NSMutableArray* marr = [NSMutableArray array];
        NSDictionary* d = nil;
        d = [NSDictionary dictionaryWithObjectsAndKeys:
             @"Manny",
             @"name",
             @"The one with glasses.",
             @"description",
             nil];
        [marr addObject:d];
        d = [NSDictionary dictionaryWithObjectsAndKeys:
             @"Moe",
             @"name",
             @"Looks a little like Governor Dewey.",
             @"description",
             nil];
        [marr addObject:d];
        d = [NSDictionary dictionaryWithObjectsAndKeys:
             @"Jack",
             @"name",
             @"The one without a mustache.",
             @"description",
             nil];
        [marr addObject:d];
        NSLog(@"%@",marr);
        self->theData = marr; 
    }
    return self;
}

- (NSMutableArray*) theDataGetter { 
    return [self mutableArrayValueForKey:@"theData"];
}

- (NSUInteger) countOfTheData {
    return [self->theData count];
}

- (id) objectInTheDataAtIndex: (NSUInteger) ix {
    return [self->theData objectAtIndex: ix];
}

- (void) insertObject: (id) val inTheDataAtIndex: (NSUInteger) ix {
    [self->theData insertObject:val atIndex:ix];
}

- (void) removeObjectFromTheDataAtIndex: (NSUInteger) ix {
    [self->theData removeObjectAtIndex: ix];
}


@end
