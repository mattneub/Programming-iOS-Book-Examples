

#import "StyledText.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@implementation StyledText
@synthesize text, theLines, theBounds;

- (void) awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tap];
    [tap release];
}

- (void) appendLinesAndBoundsOfFrame:(CTFrameRef)f context:(CGContextRef)ctx{
    CGAffineTransform t1 = 
    CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    CGAffineTransform t2 = CGAffineTransformMakeScale(1, -1);
    CGAffineTransform t = CGAffineTransformConcat(t2, t1);
    CGPathRef p = CTFrameGetPath(f);
    CGRect r = CGPathGetBoundingBox(p); // this is the frame bounds
    NSArray* lines = (NSArray*)CTFrameGetLines(f);
    [self.theLines addObjectsFromArray:lines];
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(f, CFRangeMake(0,0), origins);
    for (int i = 0; i < [lines count]; i++) {
        CTLineRef aLine = (CTLineRef)[lines objectAtIndex:i];
        CGRect b = CTLineGetImageBounds((CTLineRef)aLine, ctx);
        // the line origin plus the image bounds size is the bounds we want
        CGRect b2 = { origins[i], b.size };
        // but it is expressed in terms of the frame, so we must compensate
        b2.origin.x += r.origin.x;
        b2.origin.y += r.origin.y;
        // we must also compensate for the flippedness of the graphics context
        b2 = CGRectApplyAffineTransform(b2, t);
        [self.theBounds addObject: [NSValue valueWithCGRect:b2]];
    }
}

- (void)drawRect:(CGRect)rect {
    self.theLines = [NSMutableArray array];
    self.theBounds = [NSMutableArray array];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // flip context 
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height); 
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGRect r1 = rect;
    r1.size.width /= 2.0; // column 1
    CGRect r2 = r1;
    r2.origin.x += r2.size.width; // column 2
    CTFramesetterRef fs = 
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.text);
    // draw column 1
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, r1);
    CTFrameRef f = CTFramesetterCreateFrame(fs, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(f, ctx);
    [self appendLinesAndBoundsOfFrame:f context:ctx];
    CGPathRelease(path);
    CFRange drawnRange = CTFrameGetVisibleStringRange(f);
    CFRelease(f);
    // draw column 2
    path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, r2);
    f = CTFramesetterCreateFrame(fs, 
                                 CFRangeMake(drawnRange.location + drawnRange.length, 0), path, NULL);
    CTFrameDraw(f, ctx);
    [self appendLinesAndBoundsOfFrame:f context:ctx];
    CGPathRelease(path);
    CFRelease(f);
    CFRelease(fs);

}

- (void) tapped: (UITapGestureRecognizer*) tap {
    CGPoint loc = [tap locationInView:self];
    for (int i = 0; i < [self.theBounds count]; i++) {
        CGRect rect = [[self.theBounds objectAtIndex: i] CGRectValue];
        if (CGRectContainsPoint(rect, loc)) {
            // draw rectangle for feedback
            CALayer* lay = [CALayer layer];
            lay.frame = CGRectInset(rect, -5, -5);
            lay.borderWidth = 2;
            [self.layer addSublayer: lay];
            [lay performSelector:@selector(removeFromSuperlayer) 
                      withObject:nil afterDelay:0.3];
            // fetch the drawn string tapped on
            CTLineRef theLine = (CTLineRef)[self.theLines objectAtIndex:i];
            CFRange range = CTLineGetStringRange(theLine);
            CFStringRef s = CFStringCreateWithSubstring(
                                                        NULL, (CFStringRef)[self.text string], range);
            // ... do something with string here ...
            NSLog(@"tapped %@", s);
            CFRelease(s);
            break;
        }
    }
}


- (void)dealloc
{
    [text release];
    [theLines release];
    [theBounds release];
    [super dealloc];
}

@end
