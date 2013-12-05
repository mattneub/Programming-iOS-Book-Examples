

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *v;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
#define which 2
#if which == 1
    CALayer* lay1 = [CALayer layer];
#elif which == 2
    CALayer* lay1 = [CATransformLayer layer];
#endif
    lay1.frame = self.v.layer.bounds;
    [self.v.layer addSublayer:lay1];
    
    CGRect f = CGRectMake(0,0,100,100);
    
    // lay1 is a layer, f is a CGRect
    CALayer* lay2 = [CALayer layer];
    lay2.frame = f;
    lay2.backgroundColor = [UIColor blueColor].CGColor;
    [lay1 addSublayer:lay2];
    CALayer* lay3 = [CALayer layer];
    lay3.frame = CGRectOffset(f, 20, 30);
    lay3.backgroundColor = [UIColor greenColor].CGColor;
    lay3.zPosition = 10;
    [lay1 addSublayer:lay3];
    
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        lay1.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    });

}


@end
