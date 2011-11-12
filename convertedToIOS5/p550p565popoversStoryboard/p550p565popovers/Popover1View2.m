
#import "Popover1View2.h"


@implementation Popover1View2

-(void)awakeFromNib { // does work even though a storyboard is not exactly a nib
    [super awakeFromNib];
    // unfortunately we still have to do this...
    // as there's no way to specify these numbers in the storyboard
    self.contentSizeForViewInPopover = CGSizeMake(400,400);
}


@end
