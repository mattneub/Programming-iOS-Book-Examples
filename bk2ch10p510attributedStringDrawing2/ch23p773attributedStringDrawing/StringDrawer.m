
#import "StringDrawer.h"

// not my solution: see http://stackoverflow.com/a/25029448/341994
@implementation NSString (Drawfixer)
+ (NSStringDrawingOptions) combine:(NSStringDrawingOptions)option1 with:(NSStringDrawingOptions)option2
{
    return option1 | option2;
}
@end


/*

@implementation StringDrawer

- (void) setAttributedText:(NSAttributedString *)attributedText {
    self->_attributedText = [attributedText copy];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{

#define which 2
    
#if which == 1
    
    CGRect r = CGRectOffset(rect, 0, 2); // shoved down a little from top
    [self.attributedText drawWithRect:r options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin context:nil];

#elif which == 2
    
    NSLayoutManager* lm = [NSLayoutManager new];
    NSTextStorage* ts = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    [ts addLayoutManager:lm];
    NSTextContainer* tc =
    [[NSTextContainer alloc]
     initWithSize:rect.size];
    [lm addTextContainer:tc];
    tc.lineBreakMode = NSLineBreakByTruncatingTail;
    tc.lineFragmentPadding = 0;
    NSRange r = [lm glyphRangeForTextContainer:tc];
    [lm drawBackgroundForGlyphRange:r atPoint:CGPointMake(0,2)];
    [lm drawGlyphsForGlyphRange:r atPoint:CGPointMake(0,2)];
    
#endif
    
}
 

@end
 
 */

