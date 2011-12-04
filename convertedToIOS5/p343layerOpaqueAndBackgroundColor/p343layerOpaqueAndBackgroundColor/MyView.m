
#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyView

- (void) awakeFromNib {
    CALayer* lay = [CALayer layer];
    lay.frame = CGRectMake(50,50,150,150);
    [self.layer addSublayer:lay];
    lay.delegate = [self.superview nextResponder];
    [lay setNeedsDisplay];

}

- (void)drawRect:(CGRect)rect
{
    CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), rect);
}

@end
