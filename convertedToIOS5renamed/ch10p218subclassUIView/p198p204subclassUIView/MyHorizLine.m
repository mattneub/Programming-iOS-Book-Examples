

#import "MyHorizLine.h"


@implementation MyHorizLine

// this (initWithCoder) is new
// in the previous edition we were using a white rectangle on a white background, masking this issue
// but in the Single View Application template the background is grey

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(c, 0, 0);
    CGContextAddLineToPoint(c, self.bounds.size.width, 0);
    CGContextStrokePath(c);
}


@end
