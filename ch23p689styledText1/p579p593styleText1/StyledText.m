

#import "StyledText.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface StyledText ()
@property (nonatomic, assign) CATextLayer* textLayer;
@end

@implementation StyledText
@synthesize text, textLayer;

#define which 1 // try 2, 3, 4, 5

- (void) awakeFromNib {
    CATextLayer* lay = [[CATextLayer alloc] init];
    lay.frame = self.layer.bounds;
    [self.layer addSublayer:lay];
    self.textLayer = lay;
    
    switch (which) {
        case 1: break;
        case 3: break;
        case 2:
        case 4:
        case 5:
        {
            lay.wrapped = YES;
            lay.alignmentMode = kCAAlignmentCenter;
            self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            CGRect f = self.frame;
            f.size.width = 130;
            self.frame = f;
            
            break;
        }
    }
}

- (void) layoutSublayersOfLayer:(CALayer *)layer {
    [[layer.sublayers objectAtIndex:0] setFrame:layer.bounds];
}

// note ARC bridging

- (void)drawRect:(CGRect)rect {
    if (!self.text)
        return;
    switch (which) {
        case 1:
        case 2:
        {
            self.textLayer.string = self.text;
            break;
        }
        case 3:
        {
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            // flip context
            CGContextSaveGState(ctx);
            CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
            CGContextScaleCTM(ctx, 1.0, -1.0);    
            CTLineRef line = 
            CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self.text);
            CGContextSetTextPosition(ctx, 1, 3);
            CTLineDraw(line, ctx);
            CFRelease(line);
            CGContextRestoreGState(ctx);
            break;
        }
        case 5:
        {
            NSMutableAttributedString* mas = [self.text mutableCopy];
            NSString* s = [mas string];
            CTTextAlignment centerValue = kCTCenterTextAlignment;
            CTParagraphStyleSetting center = 
            {kCTParagraphStyleSpecifierAlignment, sizeof(centerValue), &centerValue};
            CTParagraphStyleSetting pss[1] = {center};
            CTParagraphStyleRef ps = CTParagraphStyleCreate(pss, 1);
            [mas addAttribute:(NSString*)kCTParagraphStyleAttributeName 
                        value:CFBridgingRelease(ps) 
                        range:NSMakeRange(0, [s length])];
            self.text = mas;
            // fall thru to case 4
        }
        case 4:
        {
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            // flip context
            CGContextSaveGState(ctx);
            CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
            CGContextScaleCTM(ctx, 1.0, -1.0);    
            CTFramesetterRef fs = 
            CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.text);
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, NULL, rect);
            // range (0,0) means "the whole string"
            CTFrameRef f = CTFramesetterCreateFrame(fs, CFRangeMake(0, 0), path, NULL);
            CTFrameDraw(f, ctx);
            CGPathRelease(path);
            CFRelease(f);
            CFRelease(fs);
            CGContextRestoreGState(ctx);
            break;
        }
    }
}


@end
