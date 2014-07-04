

#import "MyOverlayRenderer.h"

@interface MyOverlayRenderer ()
@property CGFloat angle;
@end

@implementation MyOverlayRenderer

- (id) initWithOverlay:(id <MKOverlay>)overlay angle: (CGFloat) ang {
    self = [super initWithOverlay:overlay];
    if (self) {
        self->_angle = ang;
    }
    return self;
}

// called many times because it's tiled

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{
    NSLog(@"draw this: %@", MKStringFromMapRect(mapRect));
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(context, 
                                   [[UIColor redColor] colorWithAlphaComponent:0.2].CGColor);
    CGContextSetLineWidth(context, 1.2/zoomScale);

    CGFloat unit = MKMapRectGetWidth([self.overlay boundingMapRect])/4.0;
    
    CGMutablePathRef p = CGPathCreateMutable();    
    CGPoint start = CGPointMake(0, unit*1.5);
    CGPoint p1 = CGPointMake(start.x+2*unit, start.y);
    CGPoint p2 = CGPointMake(p1.x, p1.y-unit);
    CGPoint p3 = CGPointMake(p2.x+unit*2, p2.y+unit*1.5);
    CGPoint p4 = CGPointMake(p2.x, p2.y+unit*3);
    CGPoint p5 = CGPointMake(p4.x, p4.y-unit);
    CGPoint p6 = CGPointMake(p5.x-2*unit, p5.y);
    CGPoint points[] = {
        start, p1, p2, p3, p4, p5, p6
    };
    // rotate the arrow around its center
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(unit*2, unit*2);
    CGAffineTransform t2 = CGAffineTransformRotate(t1, self.angle);
    CGAffineTransform t3 = CGAffineTransformTranslate(t2, -unit*2, -unit*2);
    CGPathAddLines(p, &t3, points, 7);
    CGPathCloseSubpath(p);
    
    CGContextAddPath(context, p);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(p);
}



@end
