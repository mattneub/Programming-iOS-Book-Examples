
#import "StringDrawer.h"

@implementation StringDrawer

- (void) setAttributedText:(NSAttributedString *)attributedText {
    self->_attributedText = [attributedText copy];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
    // attributed string
    CGRect r = CGRectOffset(rect, 0, 2); // shoved down a little from top
    [self.attributedText drawWithRect:r options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin context:nil];
}

@end
