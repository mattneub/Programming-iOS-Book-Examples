

#import "StyledText.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface StyledText ()
@property (nonatomic, weak) CATextLayer* textLayer;
@property (nonatomic, strong) UILabel* lab;
@end

@implementation StyledText

#define which 1 // try 2, 3, 4, 5

/*
 1: give it to CATextLayer as its string property
 2: give it to CATextLayer as its string property, and tell the layer to center and wrap,
    and narrow ourselves to demonstrate
 3: draw into current context using Core Text (CTLine) and flipping
 4: draw into current context using Core Text (CTFrame) and flipping,
    and narrow ourselves to demonstrate wrapping in the frame
 5: draw into current context using Core Text (CTFrame) and flipping,
    and use Core Text to add centering to the paragraph styling of the string,
    and narrow ourselves to demonstrate
 // --- some new ways in iOS 6 ---
 // --- WARNING: must use alternative 2 in RootViewController
 // --- we need UIFont here, not CTFont
 6: hand it to a label
 7: draw it directly into current context using NSAttributedString drawing
 8: center it using NSParagraphStyle and hand it to a label
 9: center it using NSParagraphStyle and draw it into current context with NSAttributedString drawing
 */

- (void) awakeFromNib {
    CATextLayer* lay = [[CATextLayer alloc] init];
    lay.frame = self.layer.bounds;
    [self.layer addSublayer:lay];
    self.textLayer = lay;
    
    UILabel* label = [[UILabel alloc] init];
    label.frame = self.bounds;
    label.numberOfLines = 20;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    self.lab = label;
    
    switch (which) {
        case 1: break;
        case 3: break;
        case 2:
        case 4:
        case 5:
        case 8:
        case 9:
        {
            lay.wrapped = YES;
            lay.alignmentMode = kCAAlignmentCenter;
            self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            CGRect f = self.frame;
            f.size.width = 130;
            self.frame = f;
            
            break;
        }
        case 6: break;
        case 7: break;
    }
}

- (void) layoutSublayersOfLayer:(CALayer *)layer {
    [(layer.sublayers)[0] setFrame:layer.bounds];
    self.lab.frame = self.bounds;
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
            CGPathAddRect(path, nil, rect);
            // range (0,0) means "the whole string"
            CTFrameRef f = CTFramesetterCreateFrame(fs, CFRangeMake(0, 0), path, nil);
            CTFrameDraw(f, ctx);
            CGPathRelease(path);
            CFRelease(f);
            CFRelease(fs);
            CGContextRestoreGState(ctx);
            break;
        }
        case 8: {
            NSMutableParagraphStyle* p = [NSMutableParagraphStyle new];
            p.alignment = NSTextAlignmentCenter;
            NSMutableAttributedString* mas = [self.text mutableCopy];
            [mas addAttribute:NSParagraphStyleAttributeName value:p range:NSMakeRange(0,1)];
            self.text = mas;
            // fall thru to case 6
        }
        case 6: {
            self.lab.attributedText = self.text;
            break;
        }
        case 7: {
            [self.text drawWithRect:self.bounds
                            options:NSStringDrawingUsesLineFragmentOrigin
                            context:nil];
        }
        case 9: {
            // same as case 8...
            NSMutableParagraphStyle* p = [NSMutableParagraphStyle new];
            p.alignment = NSTextAlignmentCenter;
            NSMutableAttributedString* mas = [self.text mutableCopy];
            [mas addAttribute:NSParagraphStyleAttributeName value:p range:NSMakeRange(0,1)];
            self.text = mas;
            // same as case 7
            [self.text drawWithRect:self.bounds
                            options:NSStringDrawingUsesLineFragmentOrigin
                            context:nil];
        }
    }
}


@end
