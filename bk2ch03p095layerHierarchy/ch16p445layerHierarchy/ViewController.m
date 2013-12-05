

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView* mainview = self.view;
        
    CALayer* lay1 = [CALayer new];
    lay1.frame = CGRectMake(113, 111, 132, 194);
    lay1.backgroundColor =
    [[UIColor colorWithRed:1 green:.4 blue:1 alpha:1] CGColor];
    [mainview.layer addSublayer:lay1];
    CALayer* lay2 = [CALayer new];
    lay2.backgroundColor =
    [[UIColor colorWithRed:.5 green:1 blue:0 alpha:1] CGColor];
    lay2.frame = CGRectMake(41, 56, 132, 194);
    [lay1 addSublayer:lay2];
    
#define which 0
#if which == 1
    // a view can be interspersed with sibling layers
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smiley"]];
    CGRect r = iv.frame;
    r.origin = CGPointMake(180,180);
    iv.frame = r;
    [mainview addSubview:iv];
#elif which == 2
    // a layer can have image content
    CALayer* lay4 = [CALayer new];
    UIImage* im = [UIImage imageNamed:@"smiley"];
    CGRect r = lay4.frame;
    r.origin = CGPointMake(180,180);
    r.size = im.size;
    lay4.frame = r;
    lay4.contents = (id)im.CGImage;
    [mainview.layer addSublayer:lay4];
#endif

    CALayer* lay3 = [CALayer new];
    lay3.backgroundColor =
    [[UIColor colorWithRed:1 green:0 blue:0 alpha:1] CGColor];
    lay3.frame = CGRectMake(43, 197, 160, 230);
    [mainview.layer addSublayer:lay3];


}


@end
