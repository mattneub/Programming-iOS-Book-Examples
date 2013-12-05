

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *v;

@end

@implementation ViewController

- (void) animate {
    __block CGPoint p = self.v.center;
    NSUInteger opts = UIViewKeyframeAnimationOptionCalculationModeLinear | UIViewAnimationOptionCurveLinear;
    CGFloat dur = 0.25;
    [UIView animateKeyframesWithDuration:4 delay:0 options:opts animations:^{
        self.v.alpha = 0;
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:dur
                                      animations:^{
                                          p.x += 100;
                                          p.y += 50;
                                          self.v.center = p;
                                      }];
        [UIView addKeyframeWithRelativeStartTime:.25 relativeDuration:dur
                                      animations:^{
                                          p.x -= 100;
                                          p.y += 50;
                                          self.v.center = p;
                                      }];
        [UIView addKeyframeWithRelativeStartTime:.5 relativeDuration:dur
                                      animations:^{
                                          p.x += 100;
                                          p.y += 50;
                                          self.v.center = p;
                                      }];
        [UIView addKeyframeWithRelativeStartTime:.75 relativeDuration:dur
                                      animations:^{
                                          p.x -= 100;
                                          p.y += 50;
                                          self.v.center = p;
                                      }];
    } completion:nil];
}

- (IBAction)doButton:(id)sender {
    [self animate];
}


@end
