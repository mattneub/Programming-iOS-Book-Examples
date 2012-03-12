
#import "MyView4.h"

@implementation MyView4

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void)drawLayer:(CALayer*)lay inContext:(CGContextRef)con {
    CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100));
    CGContextSetFillColorWithColor(con, [UIColor blueColor].CGColor);
    CGContextFillPath(con);
}

@end
