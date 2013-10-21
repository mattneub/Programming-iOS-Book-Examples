

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
        
    CGRect r = [self boundingRectForGlyphRange:range inTextContainer:self.textContainers[0]];
    r.origin.x += origin.x;
    r.origin.y += origin.y;
    CGContextStrokeRect(UIGraphicsGetCurrentContext(), r);
}

@end
