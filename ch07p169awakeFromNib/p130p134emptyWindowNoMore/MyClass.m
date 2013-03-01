

#import "MyClass.h"

@implementation MyClass
{
    IBOutlet UILabel* theLabel;
}

// this is a really big memory management difference from the pre-ARC version of this example
// in the book, I warn that an outlet ivar needs to be "guarded" by accessors...
// to manage its memory, because otherwise KVC will access the ivar directly,
// and retain it, causing a leak
// but under ARC no problem can arise! so the outlet ivar is all we need
// (later of course we'll use a property and synthesize the ivar instead)


@end
