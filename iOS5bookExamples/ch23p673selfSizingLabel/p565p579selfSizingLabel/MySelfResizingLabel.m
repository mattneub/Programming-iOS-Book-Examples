

#import "MySelfResizingLabel.h"


@implementation MySelfResizingLabel

// comment this out, and you'll see...
// that the default sizeToFit behavior is very different!

- (CGRect)textRectForBounds:(CGRect)bounds 
     limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGSize sz = [self.text sizeWithFont:self.font 
                      constrainedToSize:CGSizeMake(self.bounds.size.width, 10000)
                          lineBreakMode:self.lineBreakMode];
    // improved code - better width here
    return (CGRect){bounds.origin, CGSizeMake(self.bounds.size.width, sz.height)};
}


@end
