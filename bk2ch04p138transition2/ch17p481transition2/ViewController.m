

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation ViewController

- (void) animate {
    UILabel* lab2 = [[UILabel alloc] initWithFrame:self.lab.frame];
    lab2.text = ([self.lab.text isEqualToString:@"Hello"] ? @"Howdy" : @"Hello");
    [lab2 sizeToFit];
    [UIView transitionFromView:self.lab toView:lab2 duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        self.lab = lab2;
    }];
}

- (IBAction)doButton:(id)sender {
    [self animate];
}

@end
