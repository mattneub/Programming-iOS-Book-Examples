

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImage* image = [UIImage imageNamed: @"linen.png"];
    CGFloat w = 100;
    CGFloat h = 60;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,h), NO, 0);
    [image drawInRect:CGRectMake(0,0,w,h)];
    UIImage* image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage* image3 = [image2 resizableImageWithCapInsets:UIEdgeInsetsMake(0,10,0,10) resizingMode:UIImageResizingModeStretch];
    [self.seg setBackgroundImage:image3 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    NSArray* pep = @[@"manny.jpg", @"moe.jpg", @"jack.jpg"];
    for (int i = 0; i < 3; i++) {
        UIImage* image = [UIImage imageNamed: pep[i]];
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30,30), NO, 0);
        [image drawInRect:CGRectMake(0,0,30,30)];
        UIImage* image2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.seg setImage:image2 forSegmentAtIndex:i];
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1,10), NO, 0);
    [[UIColor whiteColor] set];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0,1,10));
    UIImage* div = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    [self.seg setDividerImage:div forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

@end
