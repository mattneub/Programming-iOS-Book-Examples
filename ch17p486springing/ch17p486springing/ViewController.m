
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *v;

@end

@implementation ViewController

- (IBAction)doButton:(id)sender {
    
    NSUInteger opts = UIViewAnimationOptionCurveEaseIn;
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:20 options:opts animations:^{
        CGPoint p = self.v.center;
        p.y += 100;
        self.v.center = p;
    } completion:nil];
    
    
    
    
}

@end
