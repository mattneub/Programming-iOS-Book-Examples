

#import "CompassLayer.h"

@interface CompassLayer()
@property (nonatomic, strong) CALayer* rotationLayer;
@end

@implementation CompassLayer

{
    
    BOOL _didSetup;
}


// figure 16-10

- (void) doRotate {
    NSLog(@"rotate");
    self.rotationLayer.anchorPoint = CGPointMake(1,0.5);
    self.rotationLayer.position = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds));
    self.rotationLayer.transform = CATransform3DMakeRotation(M_PI/4.0, 0, 1, 0);

}

- (void) setup {
    NSLog(@"setup");
    
    [CATransaction setDisableActions:YES];
    
    // the big change from p350 is that we now have a transform layer
    // and the other elements that we want to show in 3D are sublayers of the transform layer
    // they are set at various depths to add to the 3D effect
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/1000.0;
    self.sublayerTransform = transform;

    
    CATransformLayer* master = [CATransformLayer layer];
    master.frame = self.bounds;
    [self addSublayer: master];
    self.rotationLayer = master;

    
    // the gradient
    CAGradientLayer* g = [[CAGradientLayer alloc] init];
    g.contentsScale = [UIScreen mainScreen].scale;
    g.frame = master.bounds;
    g.colors = @[(id)[[UIColor blackColor] CGColor],
                (id)[[UIColor redColor] CGColor]];
    g.locations = @[@0.0f,
                   @1.0f];
    [master addSublayer:g];
    
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
    [master addSublayer:circle];
    circle.bounds = self.bounds;
    circle.position = CGPointMake(CGRectGetMidX(self.bounds), 
                                  CGRectGetMidY(self.bounds));
    
    circle.shadowOpacity = 0.4;

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
    [master addSublayer:arrow];
    
    arrow.shadowOpacity = 1.0;
    arrow.shadowRadius = 10;
    
    [arrow setNeedsDisplay];

    // "peg" sticking into the arrow and the circle
    CAShapeLayer* line = [[CAShapeLayer alloc] init];
    line.contentsScale = [UIScreen mainScreen].scale; // probably pointless
    line.bounds = CGRectMake(0,0,3.5,50);
    CGMutablePathRef p2 = CGPathCreateMutable();
    CGPathAddRect(p2, nil, line.bounds);
    line.path = p2;
    CGPathRelease(p2);
    line.fillColor = [[UIColor colorWithRed:1.0 green:0.95 blue:1.0 alpha:0.95] CGColor];
    line.anchorPoint = CGPointMake(0.5,0.5);
    line.position = CGPointMake(CGRectGetMidX(master.bounds), CGRectGetMidY(master.bounds));
    [master addSublayer: line];
    [line setValue:@(M_PI/2) forKeyPath:@"transform.rotation.x"];
    [line setValue:@(M_PI/2) forKeyPath:@"transform.rotation.z"];
    
    // interesting to play around with these numbers a little
    circle.zPosition = 10;
    arrow.zPosition = 20;
    line.zPosition = 15;

    
    
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
    
}


- (void) layoutSublayers {
    if (!_didSetup) {
        _didSetup = YES;
        [self setup];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self doRotate];
        });
    }
}

@end
