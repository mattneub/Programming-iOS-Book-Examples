

#import "MyView.h"


@implementation MyView

- (void)drawRect:(CGRect)rect {
    CGRect f = CGRectInset(self.bounds, 10, 10);
    CGContextRef con = UIGraphicsGetCurrentContext();
    if (self.reverse)
        CGContextStrokeEllipseInRect(con, f);
    else
        CGContextStrokeRect(con, f);
}



@end
