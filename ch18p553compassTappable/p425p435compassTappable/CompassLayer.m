

#import "CompassLayer.h"


@interface CompassLayer ()
@property (nonatomic, strong) CALayer* arrow;
@end

@implementation CompassLayer {
    BOOL _didSetup;
}

- (void) setup {
    NSLog(@"setup");
    
    [CATransaction setDisableActions:YES];
    
    // the gradient
    CAGradientLayer* g = [[CAGradientLayer alloc] init];
    g.contentsScale = [UIScreen mainScreen].scale;
    g.frame = self.bounds;
    g.colors = @[(id)[[UIColor blackColor] CGColor],
                (id)[[UIColor redColor] CGColor]];
    g.locations = @[@0.0f,
                   @1.0f];
    [self addSublayer:g];
    
    // the circle
    CAShapeLayer* circle = [[CAShapeLayer alloc] init];
    circle.contentsScale = [UIScreen mainScreen].scale;
    circle.lineWidth = 2.0;
    circle.fillColor = 
    [[UIColor colorWithRed:0.9 green:0.95 blue:0.93 alpha:0.9] CGColor];
    circle.strokeColor = [[UIColor grayColor] CGColor];
    CGMutablePathRef p = CGPathCreateMutable();
    CGPathAddEllipseInRect(p, nil, CGRectInset(self.bounds, 3, 3));
    circle.path = p;
    [self addSublayer:circle];
    circle.bounds = self.bounds;
    circle.position = CGPointMake(CGRectGetMidX(self.bounds), 
                                  CGRectGetMidY(self.bounds));
    
    // the four cardinal points
    NSArray* pts = @[@"N", @"E", @"S", @"W"];
    for (int i = 0; i < 4; i++) {
        CATextLayer* t = [[CATextLayer alloc] init];
        t.contentsScale = [UIScreen mainScreen].scale;
        t.string = pts[i];
        t.bounds = CGRectMake(0,0,40,40);
        t.position = CGPointMake(CGRectGetMidX(circle.bounds), 
                                 CGRectGetMidY(circle.bounds));
        CGFloat vert = CGRectGetMidY(circle.bounds) / CGRectGetHeight(t.bounds);
        t.anchorPoint = CGPointMake(0.5, vert);
        t.alignmentMode = kCAAlignmentCenter;
        t.foregroundColor = [[UIColor blackColor] CGColor]; 
        [t setAffineTransform:CGAffineTransformMakeRotation(i*M_PI/2.0)];
        [circle addSublayer:t];
    }
    
    // the arrow
    CALayer* arrow = [[CALayer alloc] init];
    arrow.contentsScale = [UIScreen mainScreen].scale;
    arrow.bounds = CGRectMake(0, 0, 40, 100);
    arrow.position = CGPointMake(CGRectGetMidX(self.bounds), 
                                 CGRectGetMidY(self.bounds));
    arrow.anchorPoint = CGPointMake(0.5, 0.8);
    arrow.delegate = self;
    [arrow setAffineTransform:CGAffineTransformMakeRotation(M_PI/5.0)];
    [self addSublayer:arrow];
    [arrow setNeedsDisplay];
    
    self.arrow = arrow;

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
    CGColorSpaceRef sp = CGColorSpaceCreatePattern(nil);
    CGContextSetFillColorSpace (con, sp);
    CGColorSpaceRelease (sp);
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
    CGContextRestoreGState(con);
}

- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)con {
    NSLog(@"drawLayer:inContext: for arrow");
    [self drawArrowIntoContext:con];
}

- (CALayer*) hitTest:(CGPoint)p {
    CALayer* lay = [super hitTest: p];
    if (lay == self.arrow) {
        // could override hit-test behavior here
        // for example, here we artificially restrict touchability to roughly the shaft/point area
        CGPoint pt = [self.arrow convertPoint:p fromLayer:self.superlayer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, nil, CGRectMake(10,20,20,80));
        CGPathMoveToPoint(path, nil, 0, 25);
        CGPathAddLineToPoint(path, nil, 20, 0);
        CGPathAddLineToPoint(path, nil, 40, 25);
        CGPathCloseSubpath(path);
        if (!CGPathContainsPoint(path, nil, pt, false))
            lay = nil;
        CGPathRelease(path);
        NSLog(@"%@ arrow at %@", lay ? @"hit" : @"missed", NSStringFromCGPoint(pt));
    }
    return lay;
}


- (void) layoutSublayers {
    if (!_didSetup) {
        _didSetup = YES;
        [self setup];
    }
}

- (void) rotateArrow {
    // capture current value, set final value
    CGFloat rot = M_PI/4.0;
    [CATransaction setDisableActions:YES];
    CGFloat current = [[self.arrow valueForKeyPath:@"transform.rotation.z"] floatValue];
    [self.arrow setValue: @(current + rot) 
              forKeyPath:@"transform.rotation.z"];
    // first animation (rotate and clunk) ===============
    CABasicAnimation* anim1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim1.duration = 0.8;
    CAMediaTimingFunction* clunk = 
    [CAMediaTimingFunction functionWithControlPoints:.9 :.1 :.7 :.9];
    anim1.timingFunction = clunk;
    anim1.fromValue = @(current);
    anim1.toValue = @(current + rot);
    anim1.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    // second animation (waggle) ========================
    NSMutableArray* values = [NSMutableArray array];
    [values addObject: @0.0f];
    int direction = 1;
    for (int i = 20; i < 60; i += 5, direction *= -1) { // reverse direction each time
        [values addObject: @(direction*M_PI/(float)i)];
    }
    [values addObject: @0.0f];
    CAKeyframeAnimation* anim2 = 
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim2.values = values;
    anim2.duration = 0.25;
    anim2.beginTime = anim1.duration;
    anim2.additive = YES;
    anim2.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    // group ============================================
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[anim1, anim2];
    group.duration = anim1.duration + anim2.duration;
    [self.arrow addAnimation:group forKey:nil];
}


@end
