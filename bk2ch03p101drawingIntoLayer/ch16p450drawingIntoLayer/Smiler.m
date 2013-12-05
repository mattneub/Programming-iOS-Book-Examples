

#import "Smiler.h"

@implementation Smiler

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    UIGraphicsPushContext(ctx);
    //[[UIImage imageNamed: @"smiley"] drawInRect:CGContextGetClipBoundingBox(ctx)];
    [[UIImage imageNamed: @"smiley"] drawAtPoint:CGPointZero];

    UIGraphicsPopContext();
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"%@", layer.contentsGravity);
}

@end
