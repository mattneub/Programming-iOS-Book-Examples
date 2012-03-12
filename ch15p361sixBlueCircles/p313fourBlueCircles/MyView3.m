

#import "MyView3.h"

@implementation MyView3

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void)drawLayer:(CALayer*)lay inContext:(CGContextRef)con {
    UIGraphicsPushContext(con);
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
    [[UIColor blueColor] setFill];
    [p fill];
    UIGraphicsPopContext();
}

@end
