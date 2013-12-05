
#import "MyLabel.h"

@implementation MyLabel

// a self-adjusting label

-(void)layoutSubviews {
    // NSLog(@"%@", @"layout");
    [super layoutSubviews];
    self.preferredMaxLayoutWidth = self.bounds.size.width;
}

@end
