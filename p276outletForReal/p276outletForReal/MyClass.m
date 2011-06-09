

#import "MyClass.h"


@implementation MyClass
@synthesize theLabel;

// this is what memory management for an outlet will typically *really* look like
- (void)dealloc {
    [self->theLabel release];
    [super dealloc];
}

@end
