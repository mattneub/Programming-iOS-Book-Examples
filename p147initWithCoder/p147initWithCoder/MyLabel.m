

#import "MyLabel.h"


@implementation MyLabel

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self->num = 42;
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    self.text = [NSString stringWithFormat: @"The answer is %i", self->num];
}

@end
