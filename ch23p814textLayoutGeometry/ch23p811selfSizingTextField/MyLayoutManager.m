

#import "MyLayoutManager.h"

@interface MyLayoutManager ()
@end

@implementation MyLayoutManager

-(void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin {
    [super drawBackgroundForGlyphRange:glyphsToShow atPoint:origin];
    if (!self.wordRange.length)
        return;
    NSRange range = [self glyphRangeForCharacterRange:self.wordRange actualCharacterRange:nil];
    range = NSIntersectionRange(glyphsToShow, range);
    if (!range.length)
        return;
    NSTextContainer* tc = [self textContainerForGlyphAtIndex:range.location effectiveRange:nil];
    CGRect r = [self boundingRectForGlyphRange:range inTextContainer:tc];
    r.origin.x += origin.x;
    r.origin.y += origin.y;
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    CGContextSetStrokeColorWithColor(c, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(c, 1.0);
    CGContextStrokeRect(c, r);
    CGContextRestoreGState(c);
}

@end
