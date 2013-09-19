

#import "MyView.h"

@interface MyView ()
@property (nonatomic, strong) UIImage* arrow;
@end

@implementation MyView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self->_arrow = [self arrowImage];
    }
    return self;
}

- (UIImage*) arrowImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(40,100), NO, 0.0);
    
    // obtain the current graphics context
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    
    // punch triangular hole in context clipping region
    CGContextMoveToPoint(con, 10, 100);
    CGContextAddLineToPoint(con, 20, 90);
    CGContextAddLineToPoint(con, 30, 100);
    CGContextClosePath(con);
    CGContextAddRect(con, CGContextGetClipBoundingBox(con));
    CGContextEOClip(con);
    
    // draw the vertical line, add its shape to the clipping region
    CGContextMoveToPoint(con, 20, 100);
    CGContextAddLineToPoint(con, 20, 19);
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
                                 con, grad, CGPointMake(9,0), CGPointMake(31,0), 0);
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
    
    CGContextMoveToPoint(con, 0, 25);
    CGContextAddLineToPoint(con, 20, 0);
    CGContextAddLineToPoint(con, 40, 25);
    CGContextFillPath(con);

    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return im;

}

- (void)drawRect:(CGRect)rect {
    
#define which 1
#if which == 1
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    [self.arrow drawAtPoint:CGPointMake(0,0)];
    for (int i=0; i<3; i++) {
        CGContextTranslateCTM(con, 20, 100);
        CGContextRotateCTM(con, 30 * M_PI/180.0);
        CGContextTranslateCTM(con, -20, -100);
        [self.arrow drawAtPoint:CGPointMake(0,0)];
    }
    
#elif which == 2
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetShadow(con, CGSizeMake(7, 7), 12);
    
    [self.arrow drawAtPoint:CGPointMake(0,0)];
    for (int i=0; i<3; i++) {
        CGContextTranslateCTM(con, 20, 100);
        CGContextRotateCTM(con, 30 * M_PI/180.0);
        CGContextTranslateCTM(con, -20, -100);
        [self.arrow drawAtPoint:CGPointMake(0,0)];
    }

#elif which == 3
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetShadow(con, CGSizeMake(7, 7), 12);

    CGContextBeginTransparencyLayer(con, nil);
    [self.arrow drawAtPoint:CGPointMake(0,0)];
    for (int i=0; i<3; i++) {
        CGContextTranslateCTM(con, 20, 100);
        CGContextRotateCTM(con, 30 * M_PI/180.0);
        CGContextTranslateCTM(con, -20, -100);
        [self.arrow drawAtPoint:CGPointMake(0,0)];
    }
    CGContextEndTransparencyLayer(con);
    
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
