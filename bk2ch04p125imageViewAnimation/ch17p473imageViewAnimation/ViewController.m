

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
#define which 1
#if which == 1
    
    UIImage* mars = [UIImage imageNamed: @"Mars"];
    UIGraphicsBeginImageContextWithOptions(mars.size, NO, 0);
    UIImage* empty = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSArray* arr = @[mars, empty, mars, empty, mars];
    UIImageView* iv = [[UIImageView alloc] initWithImage:empty];
    CGRect r = iv.frame;
    r.origin = CGPointMake(100,100);
    iv.frame = r;
    [self.view addSubview: iv];
    // iv.image = [UIImage imageNamed:@"smiley"];

    iv.animationImages = arr;
    iv.animationDuration = 2;
    iv.animationRepeatCount = 1;
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [iv startAnimating];
    });
    
#elif which == 2
    
    NSMutableArray* arr = [NSMutableArray array];
    float w = 18;
    for (int i = 0; i < 6; i++) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,w), NO, 0);
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(con, [UIColor redColor].CGColor);
        CGContextAddEllipseInRect(con, CGRectMake(0+i,0+i,w-i*2,w-i*2));
        CGContextFillPath(con);
        UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [arr addObject:im];
    }
    UIImage* im = [UIImage animatedImageWithImages:arr duration:0.5];
    UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b setTitle:@"Howdy" forState:UIControlStateNormal];
    [b setImage:im forState:UIControlStateNormal];
    b.center = CGPointMake(100,200);
    [b sizeToFit];
    [self.view addSubview:b];

#elif which == 3
    
    UIImage* im = [UIImage animatedImageNamed:@"pac" duration:1];
    UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b setImage:im forState:UIControlStateNormal];
    b.center = CGPointMake(100,200);
    [b sizeToFit];
    [self.view addSubview:b];

    
#endif

}


@end
