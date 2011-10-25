

#import "MyClass.h"


@implementation MyClass
@synthesize theLabel;

// this whole example is pretty much pointless now!
// under ARC there's no dealloc, so we can just declare the property strong and forget about it

@end
