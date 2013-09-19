
#import "MyView1.h"

@implementation MyView1

- (void) drawRect: (CGRect) rect {
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
    [[UIColor blueColor] setFill];
    [p fill];
}

@end
