#import "RounderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RounderView

- (CALayer*) maskOfSize:(CGSize)sz roundingCorners:(CGFloat)rad {
    CGRect r = (CGRect){CGPointZero, sz};
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(con, [UIColor colorWithWhite:0 alpha:0].CGColor);
    CGContextFillRect(con, r);
    CGContextSetFillColorWithColor(con, [UIColor colorWithWhite:0 alpha:1].CGColor);
    UIBezierPath* p = [UIBezierPath bezierPathWithRoundedRect:r cornerRadius:rad];
    [p fill];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer* mask = [CALayer layer];
    mask.frame = r;
    mask.contents = (id)im.CGImage;
    return mask;
}


- (void) configure {
    self.layer.opaque = NO;
    self.layer.needsDisplayOnBoundsChange = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder 
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // left empty so drawLayer:inContext: is called
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)con {
    CGRect r = CGContextGetClipBoundingBox(con);
    r = CGRectInset(r,1,1);
    layer.mask = [self maskOfSize:r.size roundingCorners:6];
}

@end
