

#import "MyClass.h"

@interface MyClass ()
@property (nonatomic, strong) NSMutableArray* theData;
@end

@implementation MyClass

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
        NSLog(@"initializing data:\n%@",marr);
        self->_theData = marr;
    }
    return self;
}

// KVC facade

- (NSUInteger) countOfPepBoys {
    return self.theData.count;
}

- (id) objectInPepBoysAtIndex: (NSUInteger) ix {
    return self.theData[ix];
}

- (void) insertObject: (id) val inPepBoysAtIndex: (NSUInteger) ix {
    self.theData[ix] = val;
}

- (void) removeObjectFromPepBoysAtIndex: (NSUInteger) ix {
    [self.theData removeObjectAtIndex: ix];
}


@end
