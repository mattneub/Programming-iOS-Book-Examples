
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.seg.tintColor = [UIColor redColor];
//    return;
    // background, set desired height but make width resizable
    // sufficient to set for Normal only
    UIImage* image = [UIImage imageNamed: @"linen.png"];
    CGFloat w = 100;
    CGFloat h = 60;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,h), NO, 0);
    [image drawInRect:CGRectMake(0,0,w,h)];
    UIImage* image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage* image3 =
    [image2 resizableImageWithCapInsets:UIEdgeInsetsMake(0,10,0,10)
                           resizingMode:UIImageResizingModeStretch];
    [self.seg setBackgroundImage:image3 forState:UIControlStateNormal
                      barMetrics:UIBarMetricsDefault];
    
    // segment images, redraw at final size
    NSArray* pep = @[@"manny.jpg", @"moe.jpg", @"jack.jpg"];
    for (int i = 0; i < 3; i++) {
        UIImage* image = [UIImage imageNamed: pep[i]];
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30,30), NO, 0);
        [image drawInRect:CGRectMake(0,0,30,30)];
        UIImage* image2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.seg setImage:image2 forSegmentAtIndex:i];
        [self.seg setWidth:80 forSegmentAtIndex:i];
    }
    
    // divider, set at desired width, sufficient to set for Normal only
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1,10), NO, 0);
    [[UIColor whiteColor] set];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,1,10));
    UIImage* div = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.seg setDividerImage:div
          forLeftSegmentState:UIControlStateNormal
            rightSegmentState:UIControlStateNormal 
                   barMetrics:UIBarMetricsDefault];


}


@end
