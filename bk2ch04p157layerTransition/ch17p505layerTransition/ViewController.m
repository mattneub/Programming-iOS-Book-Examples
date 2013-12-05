

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *v;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CALayer* lay = [CALayer layer];
    lay.frame = self.v.layer.bounds;
    [self.v.layer addSublayer:lay];
    lay.contents = (id)[UIImage imageNamed:@"Mars"].CGImage;
    lay.contentsGravity = kCAGravityResizeAspectFill;
    self.v.layer.masksToBounds = YES; // try making this NO to see what difference it makes
    self.v.layer.borderWidth = 2;

}
- (IBAction)doButton:(id)sender {
    
    CALayer* lay = self.v.layer.sublayers[0];
    CATransition* t = [CATransition animation];
    t.type = kCATransitionPush;
    t.subtype = kCATransitionFromBottom;
    t.duration = 2;
    [CATransaction setDisableActions:YES];
    lay.contents = (id)[UIImage imageNamed: @"Smiley"].CGImage;
    [lay addAnimation: t forKey: nil];

    
    
}


@end
