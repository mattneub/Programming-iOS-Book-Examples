

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *v;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *v_horizontalPositionConstraint;

@end

@implementation ViewController

- (IBAction)doButton:(id)sender {
    
#define which 6
#if which == 1
    
    CGPoint p = self.v.center;
    p.x += 100;
    [UIView animateWithDuration:1 animations:^{
        self.v.center = p;
    }]; // everything *looks* okay, but it isn't
    
#elif which == 2
    
    CGPoint p = self.v.center;
    p.x += 100;
    [UIView animateWithDuration:1 animations:^{
        self.v.center = p;
    } completion:^(BOOL b){
        [self.v layoutIfNeeded]; // this is what will happen at layout time
    }];

#elif which == 3
    
    NSLayoutConstraint* con = self.v_horizontalPositionConstraint;
    con.constant += 100;
    [UIView animateWithDuration:1 animations:^{
        [self.v layoutIfNeeded];
    } completion:^(BOOL b){
        // [self.v layoutIfNeeded]; // uncomment to prove there's now no problem
    }];
    
#elif which == 4
    
    [UIView animateWithDuration:0.3 delay:0
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{
                         self.v.transform = CGAffineTransformMakeScale(1.1, 1.1);
                     } completion:^(BOOL finished) {
                         self.v.transform = CGAffineTransformIdentity;
                     }];
    
#elif which == 5
    
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"transform"];
    ba.autoreverses = YES;
    ba.duration = 0.3;
    ba.toValue =
    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
    [self.v.layer addAnimation:ba forKey:nil];
    
#elif which == 6
    
    UIView* snap = [self.v snapshotViewAfterScreenUpdates:YES];
    snap.frame = self.v.frame;
    [self.v.superview addSubview:snap];
    self.v.hidden = YES;
    [UIView animateWithDuration:0.3 delay:0
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{
                         snap.transform = CGAffineTransformMakeScale(1.1, 1.1);
                     } completion:^(BOOL finished) {
                         snap.transform = CGAffineTransformIdentity;
                         self.v.hidden = NO;
                         [snap removeFromSuperview];
                     }];

    
#endif

    
}

@end
