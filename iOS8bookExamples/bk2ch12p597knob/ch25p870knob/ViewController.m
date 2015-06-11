

#import "ViewController.h"
#import "ch25p870knob-Swift.h"


@interface ViewController ()
@property (nonatomic, weak) IBOutlet MyKnob *knob;
@end

@implementation ViewController


- (IBAction)doKnob:(id)sender {
    NSLog(@"knob angle is %f", ((MyKnob*)sender).angle);
}

- (void)viewDidLoad {
    // uncomment to see the difference
    // self.knob.continuous = YES;
}

@end