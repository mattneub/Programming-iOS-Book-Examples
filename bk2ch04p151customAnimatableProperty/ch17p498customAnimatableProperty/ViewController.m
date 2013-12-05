

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *v;

@end

@implementation ViewController

- (IBAction)doButton:(id)sender {
    
    CALayer* lay = self.v.layer;
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"thickness"];
    ba.toValue = [NSNumber numberWithFloat: 10.0];
    ba.autoreverses = YES;
    [lay addAnimation:ba forKey:nil];

    
}


@end
