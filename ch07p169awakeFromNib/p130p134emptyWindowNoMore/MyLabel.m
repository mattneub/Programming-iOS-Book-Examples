

#import "MyLabel.h"

@implementation MyLabel
{
    int _num;
}

- (id) initWithCoder:(NSCoder *)aDecoder { 
    self = [super initWithCoder:aDecoder]; 
    if (self) {
        self->_num = 42; 
    }
    return self;
}

// there's no need for the separate example illustrating awakeFromNib alone
// (self.text = @"I initialized myself!")
// so I've just skipped it


- (void) awakeFromNib { 
    [super awakeFromNib]; 
    self.text = [NSString stringWithFormat: @"The answer is %i", self->_num];
    [self sizeToFit];
}

@end
