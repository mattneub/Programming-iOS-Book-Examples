

#import "MyView.h"


@implementation MyView

@synthesize reverse;



- (void)drawRect:(CGRect)rect {
    CGRect f = CGRectInset(self.bounds, 10, 10);
    CGContextRef con = UIGraphicsGetCurrentContext();
    if (reverse)
        CGContextStrokeEllipseInRect(con, f);
    else
        CGContextStrokeRect(con, f);
}



@end
