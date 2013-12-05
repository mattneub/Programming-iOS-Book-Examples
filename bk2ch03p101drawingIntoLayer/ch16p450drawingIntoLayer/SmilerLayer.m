
#import "SmilerLayer.h"

@implementation SmilerLayer

-(void)drawInContext:(CGContextRef)ctx {
    UIGraphicsPushContext(ctx);
    //[[UIImage imageNamed: @"smiley"] drawInRect:CGContextGetClipBoundingBox(ctx)];
    [[UIImage imageNamed: @"smiley"] drawAtPoint:CGPointZero];
    UIGraphicsPopContext();
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"%@", self.contentsGravity);

}

@end
