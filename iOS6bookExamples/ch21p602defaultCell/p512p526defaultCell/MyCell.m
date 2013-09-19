

#import "MyCell.h"


@implementation MyCell

// unchanged from iOS 5
// I find that if you're going to manipulate the position of the default subviews...
// it is easiest to continue using direct frame manipulation, not constraints

- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect cvb = self.contentView.bounds;
    CGRect imf = self.imageView.frame;
    imf.origin.x = cvb.size.width - imf.size.width - 5;
    self.imageView.frame = imf;
    CGRect tf = self.textLabel.frame;
    tf.origin.x = 5;
    self.textLabel.frame = tf;
}

@end
