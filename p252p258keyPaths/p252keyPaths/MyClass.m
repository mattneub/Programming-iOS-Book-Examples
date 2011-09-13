

#import "MyClass.h"


@implementation MyClass
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
        self->theData = [marr retain]; 
    }
    return self;
}

// KVC facade

- (NSUInteger) countOfPepBoys { 
    return [self.theData count];
}

- (id) objectInPepBoysAtIndex: (NSUInteger) ix { 
    return [self.theData objectAtIndex: ix];
}

- (void) insertObject: (id) val inPepBoysAtIndex: (NSUInteger) ix { 
    [self.theData insertObject:val atIndex:ix];
}

- (void) removeObjectFromPepBoysAtIndex: (NSUInteger) ix { 
    [self.theData removeObjectAtIndex: ix];
}

- (void)dealloc {
    [self->theData release];
    [super dealloc];
}

@end
