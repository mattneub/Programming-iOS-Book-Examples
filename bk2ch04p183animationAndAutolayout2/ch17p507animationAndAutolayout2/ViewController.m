

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *v;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // our nib uses autolayout...
    // ... but we intend to animation v, so we take it out of autolayout
    self.v.translatesAutoresizingMaskIntoConstraints = YES;
    // (and v's constraints in the nib are all placeholders, so they've been deleted)
}

- (IBAction)doButton:(id)sender {
    
    CGPoint p = self.v.center;
    p.x += 100;
    [UIView animateWithDuration:1 animations:^{
        // frame change works
        self.v.center = p;
    } completion:^(BOOL b){
        [UIView animateWithDuration:0.3 delay:0
                            options:UIViewAnimationOptionAutoreverse
                         animations:^{
                             // scale transform works
                             self.v.transform = CGAffineTransformMakeScale(1.1, 1.1);
                         } completion:^(BOOL finished) {
                             self.v.transform = CGAffineTransformIdentity;
                             [self.v layoutIfNeeded]; // and there's no violation of any constraints
                         }];
    }];

    
}


@end
