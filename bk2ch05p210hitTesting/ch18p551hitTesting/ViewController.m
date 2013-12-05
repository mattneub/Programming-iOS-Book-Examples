

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)doButton:(id)sender {
    NSLog(@"%@", @"button tap!");
}

- (IBAction) tapped: (UITapGestureRecognizer*) g {
    CGPoint p = [g locationOfTouch:0 inView:g.view];
    UIView* v = [g.view hitTest:p withEvent:nil];
    if (v && [v isKindOfClass:[UIImageView class]]) {
        // warning: autolayout breaks this animation (don't get me started)
        // the workaround is to use full-on Core Animation
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionAutoreverse
                         animations:^{
                             v.transform = CGAffineTransformMakeScale(1.1, 1.1);
                         } completion:^ (BOOL b) {
                             v.transform = CGAffineTransformIdentity;
                         }];
    }
}

@end
