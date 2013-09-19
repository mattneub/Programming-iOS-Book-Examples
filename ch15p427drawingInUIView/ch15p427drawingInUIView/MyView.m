

#import "MyView.h"

@implementation MyView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
#define which 1
#if which == 1
    // obtain the current graphics context
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    // draw a black (by default) vertical line, the shaft of the arrow
    CGContextMoveToPoint(con, 100, 100);
    CGContextAddLineToPoint(con, 100, 19);
    CGContextSetLineWidth(con, 20);
    CGContextStrokePath(con);
    
    // draw a red triangle, the point of the arrow
    CGContextSetFillColorWithColor(con, [[UIColor redColor] CGColor]);
    CGContextMoveToPoint(con, 80, 25);
    CGContextAddLineToPoint(con, 100, 0);
    CGContextAddLineToPoint(con, 120, 25);
    CGContextFillPath(con);
    
    // snip a triangle out of the shaft by drawing in Clear blend mode
    CGContextMoveToPoint(con, 90, 101);
    CGContextAddLineToPoint(con, 100, 90);
    CGContextAddLineToPoint(con, 110, 101);
    CGContextSetBlendMode(con, kCGBlendModeClear);
    CGContextFillPath(con);
    
#elif which == 2
    UIBezierPath* p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(100,100)];
    [p addLineToPoint:CGPointMake(100, 19)];
    [p setLineWidth:20];
    [p stroke];
    
    [[UIColor redColor] set];
    [p removeAllPoints];
    [p moveToPoint:CGPointMake(80,25)];
    [p addLineToPoint:CGPointMake(100, 0)];
    [p addLineToPoint:CGPointMake(120, 25)];
    [p fill];
    
    [p removeAllPoints];
    [p moveToPoint:CGPointMake(90,101)];
    [p addLineToPoint:CGPointMake(100, 90)];
    [p addLineToPoint:CGPointMake(110, 101)];
    [p fillWithBlendMode:kCGBlendModeClear alpha:1.0];
    
#elif which == 3
    // obtain the current graphics context
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    // punch triangular hole in context clipping region
    CGContextMoveToPoint(con, 90, 100);
    CGContextAddLineToPoint(con, 100, 90);
    CGContextAddLineToPoint(con, 110, 100);
    CGContextClosePath(con);
    CGContextAddRect(con, CGContextGetClipBoundingBox(con));
    CGContextEOClip(con);
    
    // draw the vertical line
    CGContextMoveToPoint(con, 100, 100);
    CGContextAddLineToPoint(con, 100, 19);
    CGContextSetLineWidth(con, 20);
    CGContextStrokePath(con);
    
    // draw the red triangle, the point of the arrow
    CGContextSetFillColorWithColor(con, [[UIColor redColor] CGColor]);
    CGContextMoveToPoint(con, 80, 25);
    CGContextAddLineToPoint(con, 100, 0);
    CGContextAddLineToPoint(con, 120, 25);
    CGContextFillPath(con);

#elif which == 4
    // obtain the current graphics context
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    
    // punch triangular hole in context clipping region
    CGContextMoveToPoint(con, 90, 100);
    CGContextAddLineToPoint(con, 100, 90);
    CGContextAddLineToPoint(con, 110, 100);
    CGContextClosePath(con);
    CGContextAddRect(con, CGContextGetClipBoundingBox(con));
    CGContextEOClip(con);
    
    // draw the vertical line, add its shape to the clipping region
    CGContextMoveToPoint(con, 100, 100);
    CGContextAddLineToPoint(con, 100, 19);
    CGContextSetLineWidth(con, 20);
    CGContextReplacePathWithStrokedPath(con);
    CGContextClip(con);
    
    // draw the gradient
    CGFloat locs[3] = { 0.0, 0.5, 1.0 };
    CGFloat colors[12] = {
        0.3,0.3,0.3,0.8, // starting color, transparent gray
        0.0,0.0,0.0,1.0, // intermediate color, black
        0.3,0.3,0.3,0.8 // ending color, transparent gray
    };
    CGColorSpaceRef sp = CGColorSpaceCreateDeviceGray();
    CGGradientRef grad =
    CGGradientCreateWithColorComponents (sp, colors, locs, 3);
    CGContextDrawLinearGradient (
                                 con, grad, CGPointMake(89,0), CGPointMake(111,0), 0);
    CGColorSpaceRelease(sp);
    CGGradientRelease(grad);
    
    CGContextRestoreGState(con); // done clipping
    
    // draw the red triangle, the point of the arrow
    CGContextSetFillColorWithColor(con, [[UIColor redColor] CGColor]);
    CGContextMoveToPoint(con, 80, 25);
    CGContextAddLineToPoint(con, 100, 0);
    CGContextAddLineToPoint(con, 120, 25);
    CGContextFillPath(con);

#elif which == 5
    
    // obtain the current graphics context
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    
    // punch triangular hole in context clipping region
    CGContextMoveToPoint(con, 90, 100);
    CGContextAddLineToPoint(con, 100, 90);
    CGContextAddLineToPoint(con, 110, 100);
    CGContextClosePath(con);
    CGContextAddRect(con, CGContextGetClipBoundingBox(con));
    CGContextEOClip(con);
    
    // draw the vertical line, add its shape to the clipping region
    CGContextMoveToPoint(con, 100, 100);
    CGContextAddLineToPoint(con, 100, 19);
    CGContextSetLineWidth(con, 20);
    CGContextReplacePathWithStrokedPath(con);
    CGContextClip(con);
    
    // draw the gradient
    CGFloat locs[3] = { 0.0, 0.5, 1.0 };
    CGFloat colors[12] = {
        0.3,0.3,0.3,0.8, // starting color, transparent gray
        0.0,0.0,0.0,1.0, // intermediate color, black
        0.3,0.3,0.3,0.8 // ending color, transparent gray
    };
    CGColorSpaceRef sp = CGColorSpaceCreateDeviceGray();
    CGGradientRef grad =
    CGGradientCreateWithColorComponents (sp, colors, locs, 3);
    CGContextDrawLinearGradient (
                                 con, grad, CGPointMake(89,0), CGPointMake(111,0), 0);
    CGColorSpaceRelease(sp);
    CGGradientRelease(grad);
    
    CGContextRestoreGState(con); // done clipping
    
    // draw the red triangle, the point of the arrow
    CGColorSpaceRef sp2 = CGColorSpaceCreatePattern(nil);
    CGContextSetFillColorSpace (con, sp2);
    CGColorSpaceRelease (sp2);
    CGPatternCallbacks callback = {
        0, drawStripes, nil
    };
    CGAffineTransform tr = CGAffineTransformIdentity;
    CGPatternRef patt = CGPatternCreate(nil,
                                        CGRectMake(0,0,4,4),
                                        tr,
                                        4, 4,
                                        kCGPatternTilingConstantSpacingMinimalDistortion,
                                        true,
                                        &callback);
    CGFloat alph = 1.0;
    CGContextSetFillPattern(con, patt, &alph);
    CGPatternRelease(patt);

    CGContextMoveToPoint(con, 80, 25);
    CGContextAddLineToPoint(con, 100, 0);
    CGContextAddLineToPoint(con, 120, 25);
    CGContextFillPath(con);
    
#elif which == 6
    
    // obtain the current graphics context
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    
    // punch triangular hole in context clipping region
    CGContextMoveToPoint(con, 90, 100);
    CGContextAddLineToPoint(con, 100, 90);
    CGContextAddLineToPoint(con, 110, 100);
    CGContextClosePath(con);
    CGContextAddRect(con, CGContextGetClipBoundingBox(con));
    CGContextEOClip(con);
    
    // draw the vertical line, add its shape to the clipping region
    CGContextMoveToPoint(con, 100, 100);
    CGContextAddLineToPoint(con, 100, 19);
    CGContextSetLineWidth(con, 20);
    CGContextReplacePathWithStrokedPath(con);
    CGContextClip(con);
    
    // draw the gradient
    CGFloat locs[3] = { 0.0, 0.5, 1.0 };
    CGFloat colors[12] = {
        0.3,0.3,0.3,0.8, // starting color, transparent gray
        0.0,0.0,0.0,1.0, // intermediate color, black
        0.3,0.3,0.3,0.8 // ending color, transparent gray
    };
    CGColorSpaceRef sp = CGColorSpaceCreateDeviceGray();
    CGGradientRef grad =
    CGGradientCreateWithColorComponents (sp, colors, locs, 3);
    CGContextDrawLinearGradient (
                                 con, grad, CGPointMake(89,0), CGPointMake(111,0), 0);
    CGColorSpaceRelease(sp);
    CGGradientRelease(grad);
    
    CGContextRestoreGState(con); // done clipping
    
    // draw the red triangle, the point of the arrow
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(4,4), NO, 0);
    drawStripes(nil, UIGraphicsGetCurrentContext());
    UIImage* stripes = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIColor* stripesPattern = [UIColor colorWithPatternImage:stripes];
    [stripesPattern setFill];
    UIBezierPath* p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(80,25)];
    [p addLineToPoint:CGPointMake(100,0)];
    [p addLineToPoint:CGPointMake(120,25)];
    [p fill];
    
#endif
}

void drawStripes (void *info, CGContextRef con) {
    // assume 4 x 4 cell
    CGContextSetFillColorWithColor(con, [[UIColor redColor] CGColor]);
    CGContextFillRect(con, CGRectMake(0,0,4,4));
    CGContextSetFillColorWithColor(con, [[UIColor blueColor] CGColor]);
    CGContextFillRect(con, CGRectMake(0,0,4,2));
}


@end
