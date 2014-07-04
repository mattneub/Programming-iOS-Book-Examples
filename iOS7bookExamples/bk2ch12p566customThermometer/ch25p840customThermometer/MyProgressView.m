

#import "MyProgressView.h"


@implementation MyProgressView
@synthesize value;

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGFloat ins = 2.0;
    CGRect r = CGRectInset(self.bounds, ins, ins);
    CGFloat radius = r.size.height / 2.0;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, CGRectGetMaxX(r) - radius, ins);
    CGPathAddArc(path, nil, 
                 radius+ins, radius+ins, radius, -M_PI/2.0, M_PI/2.0, true);
    CGPathAddArc(path, nil, 
                 CGRectGetMaxX(r) - radius, radius+ins, radius, M_PI/2.0, -M_PI/2.0, true);
    CGPathCloseSubpath(path);
    CGContextAddPath(c, path);
    CGContextSetLineWidth(c, 2);
    CGContextStrokePath(c);
    CGContextAddPath(c, path);
    CGContextClip(c);
    CGContextFillRect(c, CGRectMake(
                                    r.origin.x, r.origin.y, r.size.width * self.value, r.size.height));
    CGPathRelease(path);
}

@end
