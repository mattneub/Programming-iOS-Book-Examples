

#import "CompassLayer.h"


@implementation CompassLayer

# define which 1 // figure 16-7; try "2" to see figure 16-8

- (void) doRotate {
    NSLog(@"rotate");
    switch (which) {
        case 1:
        {
            self->rotationLayer.anchorPoint = CGPointMake(1,0.5); 
            self->rotationLayer.position = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds)); 
            self->rotationLayer.transform = CATransform3DMakeRotation(M_PI/4.0, 0, 1, 0);
            break;
        }
        case 2:
        {
            self->rotationLayer.anchorPoint = CGPointMake(1,0.5);
            self->rotationLayer.position = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds));
            self->rotationLayer.transform = CATransform3DMakeRotation(M_PI/4.0, 0, 1, 0);
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = -1.0/1000.0;
            self.sublayerTransform = transform;
            break;
        }
    }
}

- (void) setup {
    NSLog(@"setup");
    
    [CATransaction setDisableActions:YES];
    
    // the gradient
    CAGradientLayer* g = [[CAGradientLayer alloc] init];
    g.frame = self.bounds;
    g.colors = [NSArray arrayWithObjects:
                (id)[[UIColor blackColor] CGColor],
                [[UIColor redColor] CGColor],
                nil];
    g.locations = [NSArray arrayWithObjects:
                   [NSNumber numberWithFloat: 0.0],
                   [NSNumber numberWithFloat: 1.0],
                   nil];
    [self addSublayer:g];
    
    // the circle
    CAShapeLayer* circle = [[CAShapeLayer alloc] init];
    circle.lineWidth = 2.0;
    circle.fillColor = 
    [[UIColor colorWithRed:0.9 green:0.95 blue:0.93 alpha:0.9] CGColor];
    circle.strokeColor = [[UIColor grayColor] CGColor];
    CGMutablePathRef p = CGPathCreateMutable();
    CGPathAddEllipseInRect(p, NULL, CGRectInset(self.bounds, 3, 3));
    circle.path = p;
    [g addSublayer:circle];
    circle.bounds = self.bounds;
    circle.position = CGPointMake(CGRectGetMidX(self.bounds), 
                                  CGRectGetMidY(self.bounds));
    
    // the four cardinal points
    NSArray* pts = [NSArray arrayWithObjects: @"N", @"E", @"S", @"W", nil];
    for (int i = 0; i < 4; i++) {
        CATextLayer* t = [[CATextLayer alloc] init];
        t.string = [pts objectAtIndex: i];
        t.bounds = CGRectMake(0,0,40,30);
        t.position = CGPointMake(CGRectGetMidX(circle.bounds), 
                                 CGRectGetMidY(circle.bounds));
        CGFloat vert = (CGRectGetMidY(circle.bounds) - 5) / CGRectGetHeight(t.bounds);
        t.anchorPoint = CGPointMake(0.5, vert);
        t.alignmentMode = kCAAlignmentCenter;
        t.foregroundColor = [[UIColor blackColor] CGColor]; 
        [t setAffineTransform:CGAffineTransformMakeRotation(i*M_PI/2.0)];
        [circle addSublayer:t];
        [t release];
    }
    
    // the arrow
    CALayer* arrow = [[CALayer alloc] init];
    arrow.bounds = CGRectMake(0, 0, 40, 100);
    arrow.position = CGPointMake(CGRectGetMidX(self.bounds), 
                                 CGRectGetMidY(self.bounds));
    arrow.anchorPoint = CGPointMake(0.5, 0.8);
    arrow.delegate = self;
    [arrow setAffineTransform:CGAffineTransformMakeRotation(M_PI/5.0)];
    [g addSublayer:arrow];
    [arrow setNeedsDisplay];
        
    [arrow release];
    
    [circle release];
    
    self->rotationLayer = g;
    [g release];

}

void drawStripes (void *info, CGContextRef con) {
    // assume 4 x 4 cell
    CGContextSetFillColorWithColor(con, [[UIColor redColor] CGColor]);
    CGContextFillRect(con, CGRectMake(0,0,4,4));
    CGContextSetFillColorWithColor(con, [[UIColor blueColor] CGColor]);
    CGContextFillRect(con, CGRectMake(0,0,4,2));
}

- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)con {
    
    NSLog(@"drawLayer:inContext: for arrow");
        
    // punch triangular hole in context clipping region
    CGContextMoveToPoint(con, 10, 100);
    CGContextAddLineToPoint(con, 20, 90);
    CGContextAddLineToPoint(con, 30, 100);
    CGContextClosePath(con);
    CGContextAddRect(con, CGRectMake(0,0,40,100));
    CGContextEOClip(con);    
    
    
    // draw a black (by default) vertical line, the shaft of the arrow
    CGContextMoveToPoint(con, 20, 100);
    CGContextAddLineToPoint(con, 20, 19);
    CGContextSetLineWidth(con, 20);
    CGContextStrokePath(con);
    
    // draw a patterned triangle, the point of the arrow
    CGColorSpaceRef sp = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace (con, sp);
    CGColorSpaceRelease (sp);
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
    
}


- (void) layoutSublayers {
    static BOOL didSetup = NO;
    if (!didSetup) {
        didSetup = YES;
        [self setup];
        [self performSelector:@selector(doRotate) withObject:nil afterDelay:1.0];
    }
}

@end
