
#import "MyView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyView

// this is the view in upper left

- (void) awakeFromNib {
    // give it a sublayer and give the sublayer a delegate, and draw
    // see ViewController for the rest
    CALayer* lay = [CALayer layer];
    lay.frame = CGRectMake(50,50,150,150);
    [self.layer addSublayer:lay];
    lay.delegate = [self.superview nextResponder];
    [lay setNeedsDisplay];

}

- (void)drawRect:(CGRect)rect
{
    // this is (a) just to puts something interesting behind the sublayer
    // but also (b) to remind you that in drawRect, CGContextClearRect punches thru the
    // background color - but in a sublayer, that's not the case
    
    CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), rect);
    CGContextClearRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,40,40));
}

@end
