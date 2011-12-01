

#import "MyImageView1.h"

@implementation MyImageView1

- (void) awakeFromNib {
    [super awakeFromNib];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), NO, 0);
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
    [[UIColor blueColor] setFill];
    [p fill];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = im;
}

@end
