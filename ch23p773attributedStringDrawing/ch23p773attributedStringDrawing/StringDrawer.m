
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
    
    /*
    
    NSMutableAttributedString* mas = [self.attributedText mutableCopy];
    NSRange range = [mas.string rangeOfString:@"Four"];
    NSMutableParagraphStyle* para = [mas attribute:NSParagraphStyleAttributeName atIndex:range.location effectiveRange:&range];
    para.lineBreakMode = NSLineBreakByTruncatingTail;
    [mas addAttribute:NSParagraphStyleAttributeName value:para range:range];
    
    [mas drawInRect:r];
     
     */
}

@end
