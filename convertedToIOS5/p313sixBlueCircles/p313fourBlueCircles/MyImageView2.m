
#import "MyImageView2.h"

@implementation MyImageView2

- (void) awakeFromNib {
    [super awakeFromNib];
    UIGraphicsBeginImageContext(CGSizeMake(100,100));
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100));
    CGContextSetFillColorWithColor(con, [UIColor blueColor].CGColor);
    CGContextFillPath(con);
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = im;
}


@end
