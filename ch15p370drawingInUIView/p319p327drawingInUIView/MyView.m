

#import "MyView.h"

// notice that no memory management here changes just because of ARC
// ARC has nothing to do with C APIs like Core Graphics

@implementation MyView

/*
CGImageRef flip (CGImageRef im) {
    CGSize sz = CGSizeMake(CGImageGetWidth(im), CGImageGetHeight(im));
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, sz.width, sz.height), im);
    CGImageRef result = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    UIGraphicsEndImageContext();
    return result;
}
 */

void drawStripes (void *info, CGContextRef con) {
    // assume 4 x 4 cell
    CGContextSetFillColorWithColor(con, [[UIColor redColor] CGColor]);
    CGContextFillRect(con, CGRectMake(0,0,4,4));
    CGContextSetFillColorWithColor(con, [[UIColor blueColor] CGColor]);
    CGContextFillRect(con, CGRectMake(0,0,4,2));
}


#define which 1 // substitute "2" thru "9" to see other examples
                // added "10" to use transparencyLayer

- (void)drawRect:(CGRect)rect {
    switch (which) {
        case 1:
        {
            // same as split mars earlier, only now we're drawing in drawRect instead of making a UIImage
            
            CGRect b = self.bounds;
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CGSize sz = [mars size];
            CGImageRef marsCG = [mars CGImage];
            CGSize szCG = CGSizeMake(CGImageGetWidth(marsCG), CGImageGetHeight(marsCG));
            CGImageRef marsLeft = CGImageCreateWithImageInRect(marsCG, 
                                                               CGRectMake(0,0,szCG.width/2.0,szCG.height));
            CGImageRef marsRight = CGImageCreateWithImageInRect(marsCG, 
                                                                CGRectMake(szCG.width/2.0,0,szCG.width/2.0,szCG.height));
            [[UIImage imageWithCGImage:marsLeft 
                                 scale:[mars scale] 
                           orientation:UIImageOrientationUp] 
             drawAtPoint:CGPointMake(0,0)];
            [[UIImage imageWithCGImage:marsRight 
                                 scale:[mars scale] 
                           orientation:UIImageOrientationUp] 
             drawAtPoint:CGPointMake(b.size.width-sz.width/2.0,0)];
            CGImageRelease(marsLeft); CGImageRelease(marsRight);
            
            break;
        }
        case 2:
        {
            // figure 15-5
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
            break;
        }
        case 3:
        {
            // figure 15-5 using UIBezierPath instead of CG drawing
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
            break;
        }
        case 4:
        {
            // like case 2, but we snip the arrow's tail with clipping
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
            break;

        }
        case 5:
        {
            // gradient shaft, figure 15-6
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
            CGGradientRef grad = CGGradientCreateWithColorComponents (sp, colors, locs, 3);
            CGContextDrawLinearGradient (con, grad, CGPointMake(89,0), CGPointMake(111,0), 0);
            CGColorSpaceRelease(sp);
            CGGradientRelease(grad);
            
            CGContextRestoreGState(con); // done clipping
            
            // draw the red triangle, the point of the arrow
            CGContextSetFillColorWithColor(con, [[UIColor redColor] CGColor]);
            CGContextMoveToPoint(con, 80, 25);
            CGContextAddLineToPoint(con, 100, 0);
            CGContextAddLineToPoint(con, 120, 25);
            CGContextFillPath(con);
            
            break;
        }
        case 6:
        {
            // patterned arrowhead, figure 15-7
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
            CGGradientRef grad = CGGradientCreateWithColorComponents (sp, colors, locs, 3);
            CGContextDrawLinearGradient (con, grad, CGPointMake(89,0), CGPointMake(111,0), 0);
            CGColorSpaceRelease(sp);
            CGGradientRelease(grad);
            
            CGContextRestoreGState(con); // done clipping
            
            // draw the patterned triangle, the point of the arrow
            CGColorSpaceRef sp2 = CGColorSpaceCreatePattern(NULL);
            CGContextSetFillColorSpace (con, sp2);
            CGColorSpaceRelease (sp2);
            CGPatternCallbacks callback = {
                0, &drawStripes, NULL
            };
            CGAffineTransform tr = CGAffineTransformIdentity;
            CGPatternRef patt = CGPatternCreate(NULL,
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
            
            break;
        }
        case 7:
        {
            // CTM, figure 15-8
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(40,100), NO, 0.0);
            CGContextRef con = UIGraphicsGetCurrentContext();
            CGContextSaveGState(con);
            // draw the arrow into the image context
            // draw it at (0,0)! adjust all x-values by subtracting 80
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
            CGGradientRef grad = CGGradientCreateWithColorComponents (sp, colors, locs, 3);
            CGContextDrawLinearGradient (con, grad, CGPointMake(9,0), CGPointMake(31,0), 0);
            CGColorSpaceRelease(sp);
            CGGradientRelease(grad);
            
            CGContextRestoreGState(con); // done clipping
            
            // draw the patterned triangle, the point of the arrow
            CGColorSpaceRef sp2 = CGColorSpaceCreatePattern(NULL);
            CGContextSetFillColorSpace (con, sp2);
            CGColorSpaceRelease (sp2);
            CGPatternCallbacks callback = {
                0, &drawStripes, NULL
            };
            CGAffineTransform tr = CGAffineTransformIdentity;
            CGPatternRef patt = CGPatternCreate(NULL,
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
            
            con = UIGraphicsGetCurrentContext();
            
            [im drawAtPoint:CGPointMake(0,0)];
            for (int i=0; i<3; i++) {
                CGContextTranslateCTM(con, 20, 100);
                CGContextRotateCTM(con, 30 * M_PI/180.0);
                CGContextTranslateCTM(con, -20, -100);
                [im drawAtPoint:CGPointMake(0,0)];
            }
            break;
        }
        case 8:
        {
            // same as case 1, using a CTM
            CGRect b = self.bounds;
            UIImage* mars = [UIImage imageNamed:@"Mars.png"];
            CGSize sz = [mars size];
            CGImageRef marsCG = [mars CGImage];
            CGSize szCG = CGSizeMake(CGImageGetWidth(marsCG), CGImageGetHeight(marsCG));
            CGImageRef marsLeft = CGImageCreateWithImageInRect(marsCG, 
                                                               CGRectMake(0,0,szCG.width/2.0,szCG.height));
            CGImageRef marsRight = CGImageCreateWithImageInRect(marsCG, 
                                                                CGRectMake(szCG.width/2.0,0,szCG.width/2.0,szCG.height));
            CGContextRef con = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(con, 0, sz.height);
            CGContextScaleCTM(con, 1.0, -1.0);
            CGContextDrawImage(con, 
                               CGRectMake(0,0,sz.width/2.0,sz.height), 
                               marsLeft);
            CGContextDrawImage(con, 
                               CGRectMake(b.size.width-sz.width/2.0, 0, sz.width/2.0, sz.height), 
                               marsRight);
            CGImageRelease(marsLeft); CGImageRelease(marsRight);
            
            break;
        }
        case 9:
        {
            // same as case 7, with shadow, figure 15-9
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(40,100), NO, 0.0);
            CGContextRef con = UIGraphicsGetCurrentContext();
            CGContextSaveGState(con);
            // draw the arrow into the image context
            // draw it at (0,0)! adjust all x-values by subtracting 80
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
            CGGradientRef grad = CGGradientCreateWithColorComponents (sp, colors, locs, 3);
            CGContextDrawLinearGradient (con, grad, CGPointMake(9,0), CGPointMake(31,0), 0);
            CGColorSpaceRelease(sp);
            CGGradientRelease(grad);
            
            CGContextRestoreGState(con); // done clipping
            
            // draw the patterned triangle, the point of the arrow
            CGColorSpaceRef sp2 = CGColorSpaceCreatePattern(NULL);
            CGContextSetFillColorSpace (con, sp2);
            CGColorSpaceRelease (sp2);
            CGPatternCallbacks callback = {
                0, &drawStripes, NULL
            };
            CGAffineTransform tr = CGAffineTransformIdentity;
            CGPatternRef patt = CGPatternCreate(NULL,
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
            
            con = UIGraphicsGetCurrentContext();
            
            CGContextSetShadow(con, CGSizeMake(7, 7), 12);
            
            [im drawAtPoint:CGPointMake(0,0)];
            for (int i=0; i<3; i++) {
                CGContextTranslateCTM(con, 20, 100);
                CGContextRotateCTM(con, 30 * M_PI/180.0);
                CGContextTranslateCTM(con, -20, -100);
                [im drawAtPoint:CGPointMake(0,0)];
            }
            break;
        }
        case 10: { // new for second edition, not in original book
            // same as case 9, with transparency layer before we draw the shadowed material
            // hard to see the difference, but the fact is that case 9 hides a subtle bug:
            // the arrows are able to cast shadows on one another, whereas what we want
            // is for all the arrows to be drawn and to cast a single shadow collectively
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(40,100), NO, 0.0);
            CGContextRef con = UIGraphicsGetCurrentContext();
            CGContextSaveGState(con);
            // draw the arrow into the image context
            // draw it at (0,0)! adjust all x-values by subtracting 80
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
            CGGradientRef grad = CGGradientCreateWithColorComponents (sp, colors, locs, 3);
            CGContextDrawLinearGradient (con, grad, CGPointMake(9,0), CGPointMake(31,0), 0);
            CGColorSpaceRelease(sp);
            CGGradientRelease(grad);
            
            CGContextRestoreGState(con); // done clipping
            
            // draw the patterned triangle, the point of the arrow
            CGColorSpaceRef sp2 = CGColorSpaceCreatePattern(NULL);
            CGContextSetFillColorSpace (con, sp2);
            CGColorSpaceRelease (sp2);
            CGPatternCallbacks callback = {
                0, &drawStripes, NULL
            };
            CGAffineTransform tr = CGAffineTransformIdentity;
            CGPatternRef patt = CGPatternCreate(NULL,
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
            
            con = UIGraphicsGetCurrentContext();
            
            CGContextSetShadow(con, CGSizeMake(7, 7), 12);
            
            CGContextBeginTransparencyLayer(con, NULL);
            
            [im drawAtPoint:CGPointMake(0,0)];
            for (int i=0; i<3; i++) {
                CGContextTranslateCTM(con, 20, 100);
                CGContextRotateCTM(con, 30 * M_PI/180.0);
                CGContextTranslateCTM(con, -20, -100);
                [im drawAtPoint:CGPointMake(0,0)];
            }
            
            CGContextEndTransparencyLayer(con);
            break;
        }
    }
}

@end
