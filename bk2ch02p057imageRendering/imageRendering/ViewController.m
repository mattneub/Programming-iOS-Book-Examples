

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *b;
@property (weak, nonatomic) IBOutlet UITabBarItem *tbi;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIImage* im = [[UIImage imageNamed:@"Smiley"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.b setBackgroundImage:im forState:UIControlStateNormal];
    
    im = [[UIImage imageNamed:@"smiley2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tbi.image = im;
}


@end
