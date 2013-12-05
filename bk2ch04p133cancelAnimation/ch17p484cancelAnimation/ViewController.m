

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *v;
@property CGPoint pOrig;
@property CGPoint pFinal;
@end

@implementation ViewController

#define which 1

#if which == 1

-(void) animate {
    CGPoint p = self.v.center;
    p.x += 100;
    self.pFinal = p;
    [UIView animateWithDuration:4 animations:^{
        self.v.center = p;
    }];
}

-(void) cancel {
    [UIView animateWithDuration:0 animations:^{
        CGPoint p = self.pFinal;
        p.x += 1;
        self.v.center = p;
    } completion:^(BOOL finished) {
        CGPoint p = self.pFinal;
        self.v.center = p;
    }];
}

#elif which == 2

-(void) animate {
    CGPoint p = self.v.center;
    self.pOrig = p;
    p.x += 100;
    NSUInteger opts = UIViewAnimationOptionAutoreverse |
    UIViewAnimationOptionRepeat;
    [UIView animateWithDuration:1 delay:0 options:opts
         animations:^{
             self.v.center = p;
         } completion: nil];
}

-(void) cancel {
    NSUInteger opts = UIViewAnimationOptionBeginFromCurrentState;
    [UIView animateWithDuration:0.1 delay:0 options:opts
        animations:^{
            self.v.center = self.pOrig;
        } completion:nil];
}

#endif

- (IBAction)doStart:(id)sender {
    [self animate];
}

- (IBAction)doStop:(id)sender {
    [self cancel];
}

@end
