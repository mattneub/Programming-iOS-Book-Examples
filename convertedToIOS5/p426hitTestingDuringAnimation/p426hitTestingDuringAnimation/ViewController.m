
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
    oldButtonCenter = button.center;
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
    button.center = oldButtonCenter;

    switch (which) {
        case 1: {
            UIViewAnimationOptions opt = UIViewAnimationOptionAllowUserInteraction;
            [UIView animateWithDuration:10 delay:0 options:opt animations:^{
                button.center = goal;
            } completion:^(BOOL f) {
            }];

            break;
        }
        case 2: {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:10];
            button.center = goal;
            [UIView commitAnimations];
            
            break;
        }
        case 3: {
            CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"position"];
            ba.duration = 10;
            ba.fromValue = [NSValue valueWithCGPoint:oldButtonCenter];
            ba.toValue = [NSValue valueWithCGPoint:goal];
            [button.layer addAnimation:ba forKey:nil];
            button.layer.position = goal;
            
            break;
        }
    }
}



@end
