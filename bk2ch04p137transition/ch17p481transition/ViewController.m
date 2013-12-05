

#import "ViewController.h"
#import "MyView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property (weak, nonatomic) IBOutlet MyView *v;
@property (weak, nonatomic) IBOutlet UIView *outer;
@property (weak, nonatomic) IBOutlet UIView *inner;


@end

@implementation ViewController

- (void) animate {

    NSUInteger opts = UIViewAnimationOptionTransitionFlipFromLeft;
    [UIView transitionWithView:self.iv duration:0.8 options:opts animations:^{
        
        self.iv.image = [UIImage imageNamed:@"Smiley"];

//        CGPoint p = self.iv.center;
//        p.y += 100;
//        self.iv.center = p;

    } completion:nil];
    
    // =================
    
    self.v.reverse = !self.v.reverse;
    [UIView transitionWithView:self.v duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self.v setNeedsDisplay];
                    } completion:nil];
    
    // ==================

    opts = UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionAllowAnimatedContent;
    [UIView transitionWithView:self.outer duration:1 options:opts
                    animations:^{

                        CGRect f = self.inner.frame;
                        f.size.width = self.outer.frame.size.width;
                        f.origin.x = 0;
                        self.inner.frame = f;

                    
                    } completion:nil];

    

}

- (IBAction)doButton:(id)sender {
    [self animate];
}

@end
