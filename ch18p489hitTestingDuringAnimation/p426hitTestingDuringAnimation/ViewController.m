
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController {
    IBOutlet UIButton *button;
    CGPoint oldButtonCenter;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self->oldButtonCenter = self->button.center; // so we can test repeatedly
}

- (IBAction)tapme:(id)sender {
    NSLog(@"tap! (the button's action method)");
}

#define which 1 // try 2, 3; no diff, just proving it's the same for all ways of animating

// run the app, tap Start, tap the button in motion, watch the log
// shows how you can tap on an animated button using hit-test munging...
// but the button "swallows the touch" so you have to use some other means to get it to respond

- (IBAction)start:(id)sender {
    NSLog(@"you tapped Start");
    CGPoint goal = CGPointMake(100,400);
    self->button.center = self->oldButtonCenter;

    switch (which) {
        case 1: {
            UIViewAnimationOptions opt = UIViewAnimationOptionAllowUserInteraction;
            [UIView animateWithDuration:10 delay:0 options:opt animations:^{
                self->button.center = goal;
            } completion:nil];

            break;
        }
        case 2: {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:10];
            self->button.center = goal;
            [UIView commitAnimations];
            
            break;
        }
        case 3: {
            CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"position"];
            ba.duration = 10;
            ba.fromValue = [NSValue valueWithCGPoint:self->oldButtonCenter];
            ba.toValue = [NSValue valueWithCGPoint:goal];
            [self->button.layer addAnimation:ba forKey:nil];
            self->button.layer.position = goal;
            
            break;
        }
    }
}



@end
