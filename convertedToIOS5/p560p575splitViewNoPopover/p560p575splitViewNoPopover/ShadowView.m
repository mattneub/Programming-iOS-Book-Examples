

#import <QuartzCore/QuartzCore.h>
#import "ShadowView.h"

@implementation ShadowView
@synthesize showsShadow;

- (void) setShowsShadow: (BOOL) val {
    self->showsShadow = val;
    [self setNeedsDisplay];
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
    UIBezierPath* p = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(r, 1, 1) cornerRadius:6];
    layer.shadowPath = p.CGPath;
    if (self.showsShadow) {
        layer.shadowColor = [UIColor grayColor].CGColor;
        layer.shadowOffset = CGSizeMake(6,0);
        layer.shadowOpacity = 0.3;
        layer.shadowRadius = 1;
    } else {
        layer.shadowOpacity = 0;
    }
    CGContextSetStrokeColorWithColor(con, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(con, 2);
    CGContextAddPath(con, p.CGPath);
    CGContextStrokePath(con);
}


@end
