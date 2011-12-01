

#import "MyImageView1.h"

@implementation MyImageView1

- (void) awakeFromNib {
    [super awakeFromNib];
    UIGraphicsBeginImageContext(CGSizeMake(100,100));
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
    [[UIColor blueColor] setFill];
    [p fill];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = im;
}

@end
