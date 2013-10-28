
#import "MyShrinkingButton.h"


@implementation MyShrinkingButton

- (CGRect)backgroundRectForBounds:(CGRect)bounds {
    CGRect result = [super backgroundRectForBounds:bounds];
    if (self.highlighted)
        result = CGRectInset(result, 3, 3);
    return result;
}

-(CGSize)intrinsicContentSize {
    CGSize sz = [super intrinsicContentSize];
    sz.height += 16;
    sz.width += 20;
    return sz;
}


@end
