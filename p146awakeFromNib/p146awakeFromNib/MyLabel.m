

#import "MyLabel.h"


@implementation MyLabel

- (void) awakeFromNib 
{ 
    [super awakeFromNib]; 
    self.text = @"I initialized myself!";
}

@end
