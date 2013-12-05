

#import "MyView.h"

@implementation MyView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        // self.layer.opaque = NO;
        self.backgroundColor = [UIColor redColor];
        // clearRect will cause a black square
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:1];
        // but uncomment the next line: clearRect will cause a clear square!
        // self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.99];
        
        NSLog(@"layer opaque: %d", self.layer.opaque); // explaining why this happens, see ch. 16
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(con, [UIColor blueColor].CGColor);
    CGContextFillRect(con, rect);
    CGContextClearRect(con, CGRectMake(0,0,30,30));
}

@end
