

#import "CompassLayer.h"


@implementation CompassLayer
@synthesize theArrow;

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
    [g release];
    
    // the circle
    CAShapeLayer* circle = [[CAShapeLayer alloc] init];
    circle.lineWidth = 2.0;
    circle.fillColor = 
    [[UIColor colorWithRed:0.9 green:0.95 blue:0.93 alpha:0.9] CGColor];
    circle.strokeColor = [[UIColor grayColor] CGColor];
    CGMutablePathRef p = CGPathCreateMutable();
    CGPathAddEllipseInRect(p, NULL, CGRectInset(self.bounds, 3, 3));
    circle.path = p;
    [self addSublayer:circle];
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
    [self addSublayer:arrow];
    [arrow setNeedsDisplay];
    
    self.theArrow = arrow;
    [arrow release];
    
    [circle release];

}

void drawStripes (void *info, CGContextRef con) {
    // assume 4 x 4 cell
    CGContextSetFillColorWithColor(con, [[UIColor redColor] CGColor]);
    CGContextFillRect(con, CGRectMake(0,0,4,4));
    CGContextSetFillColorWithColor(con, [[UIColor blueColor] CGColor]);
    CGContextFillRect(con, CGRectMake(0,0,4,2));
}

- (void) drawArrowIntoContext:(CGContextRef) con {
    
    CGContextSaveGState(con);
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
    CGContextRestoreGState(con);
}

- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)con {
    NSLog(@"drawLayer:inContext: for arrow");
    [self drawArrowIntoContext:con];
}

- (CALayer*) hitTest:(CGPoint)p {
    CALayer* lay = [super hitTest: p];
    if (lay == self.theArrow) {
        // could override hit-test behavior here
        // for example, here we artificially restrict touchability to roughly the shaft/point area
        CGPoint pt = [self.theArrow convertPoint:p fromLayer:self.superlayer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(10,20,20,80));
        CGPathMoveToPoint(path, NULL, 0, 25);
        CGPathAddLineToPoint(path, NULL, 20, 0);
        CGPathAddLineToPoint(path, NULL, 40, 25);
        CGPathCloseSubpath(path);
        if (!CGPathContainsPoint(path, NULL, pt, false))
            lay = nil;
        CGPathRelease(path);
        NSLog(@"%@ arrow at %@", lay ? @"hit" : @"missed", NSStringFromCGPoint(pt));
    }
    return lay;
}


- (void) layoutSublayers {
    static BOOL didSetup = NO;
    if (!didSetup) {
        didSetup = YES;
        [self setup];
    }
}

- (void) rotateArrow {
    // p. 381
    // capture current value, set final value
    CGFloat rot = M_PI/4.0;
    [CATransaction setDisableActions:YES];
    CGFloat current = [[self.theArrow valueForKeyPath:@"transform.rotation.z"] floatValue];
    [self.theArrow setValue: [NSNumber numberWithFloat: current + rot] 
              forKeyPath:@"transform.rotation.z"];
    // first animation (rotate and clunk) ===============
    CABasicAnimation* anim1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim1.duration = 0.8;
    CAMediaTimingFunction* clunk = 
    [CAMediaTimingFunction functionWithControlPoints:.9 :.1 :.7 :.9];
    anim1.timingFunction = clunk;
    anim1.fromValue = [NSNumber numberWithFloat: current];
    anim1.toValue = [NSNumber numberWithFloat: current + rot];
    anim1.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    // second animation (waggle) ========================
    NSMutableArray* values = [NSMutableArray array];
    [values addObject: [NSNumber numberWithFloat:0]];
    int direction = 1;
    for (int i = 20; i < 60; i += 5, direction *= -1) { // reverse direction each time
        [values addObject: [NSNumber numberWithFloat: direction*M_PI/(float)i]];
    }
    [values addObject: [NSNumber numberWithFloat:0]];
    CAKeyframeAnimation* anim2 = 
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim2.values = values;
    anim2.duration = 0.25;
    anim2.beginTime = anim1.duration;
    anim2.additive = YES;
    anim2.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    // group ============================================
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects: anim1, anim2, nil];
    group.duration = anim1.duration + anim2.duration;
    [self.theArrow addAnimation:group forKey:nil];
}

- (void)dealloc {
    [super dealloc];
}
@end
