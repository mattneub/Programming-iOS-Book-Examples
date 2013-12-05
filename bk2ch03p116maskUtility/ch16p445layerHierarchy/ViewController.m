

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (CALayer*) maskOfSize:(CGSize)sz roundingCorners:(CGFloat)rad {
    CGRect r = (CGRect){CGPointZero, sz};
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(
                                   con,[UIColor colorWithWhite:0 alpha:0].CGColor);
    CGContextFillRect(con, r);
    CGContextSetFillColorWithColor(
                                   con,[UIColor colorWithWhite:0 alpha:1].CGColor);
    UIBezierPath* p =
    [UIBezierPath bezierPathWithRoundedRect:r cornerRadius:rad];
    [p fill];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer* mask = [CALayer layer];
    mask.frame = r;
    mask.contents = (id)im.CGImage;
    return mask;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView* mainview = self.view;
    CALayer* lay = [CALayer layer];
    lay.frame = mainview.layer.bounds;
    [mainview.layer addSublayer:lay];
    
    CALayer* lay1 = [CALayer new];
    lay1.frame = CGRectMake(113, 111, 132, 194);
    lay1.backgroundColor =
    [[UIColor colorWithRed:1 green:.4 blue:1 alpha:1] CGColor];
    [lay addSublayer:lay1];
    CALayer* lay2 = [CALayer new];
    lay2.backgroundColor =
    [[UIColor colorWithRed:.5 green:1 blue:0 alpha:1] CGColor];
    lay2.frame = CGRectMake(41, 56, 132, 194);
    [lay1 addSublayer:lay2];
    CALayer* lay3 = [CALayer new];
    lay3.backgroundColor =
    [[UIColor colorWithRed:1 green:0 blue:0 alpha:1] CGColor];
    lay3.frame = CGRectMake(43, 197, 160, 230);
    [lay addSublayer:lay3];
    
    CALayer* mask = [self maskOfSize:CGSizeMake(100,100) roundingCorners:20];
    CGRect r = mask.frame;
    r.origin = CGPointMake(110,160);
    mask.frame = r;
    lay.mask = mask;
    
}

- (void) viewDidAppear:(BOOL)animated {
    self.view.window.backgroundColor = [UIColor whiteColor];
}


@end
