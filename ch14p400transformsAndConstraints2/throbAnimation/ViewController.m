

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *v1;
@property (weak, nonatomic) IBOutlet UIView *v2;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.v2.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doTest:(id)sender {
    [UIView animateWithDuration:0.3 delay:0
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{
                         self.v1.transform = CGAffineTransformMakeScale(1.1, 1.1);
                     } completion:^(BOOL finished) {
                         self.v1.transform = CGAffineTransformIdentity;
                     }];
    [UIView animateWithDuration:0.3 delay:0
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{
                         self.v2.transform = CGAffineTransformMakeScale(1.1, 1.1);
                     } completion:^(BOOL finished) {
                         self.v2.transform = CGAffineTransformIdentity;
                     }];
}


@end
