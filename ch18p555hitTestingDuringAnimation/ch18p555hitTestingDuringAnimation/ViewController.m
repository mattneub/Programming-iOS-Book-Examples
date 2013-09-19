

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController {
    CGPoint _oldButtonCenter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self->_oldButtonCenter = self.button.center; // so we can test repeatedly
}

- (IBAction)tapme:(id)sender {
    NSLog(@"tap! (the button's action method)");
}

- (IBAction)start:(id)sender {
    NSLog(@"you tapped Start");
    CGPoint goal = CGPointMake(100,400);
    self.button.center = self->_oldButtonCenter;
    
#define which 1 // try 2; no diff, just proving it's the same for both ways of animating
    
#if which == 1
    
    UIViewAnimationOptions opt = UIViewAnimationOptionAllowUserInteraction;
    [UIView animateWithDuration:10 delay:0 options:opt animations:^{
        self.button.center = goal;
    } completion:nil];
    
#elif which == 2
    
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"position"];
    ba.duration = 10;
    ba.fromValue = [NSValue valueWithCGPoint:self->_oldButtonCenter];
    ba.toValue = [NSValue valueWithCGPoint:goal];
    [self.button.layer addAnimation:ba forKey:nil];
    self.button.layer.position = goal;
    
#endif
    
    
}


@end
