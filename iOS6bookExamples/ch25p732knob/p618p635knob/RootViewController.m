

#import "RootViewController.h"
#import "MyKnob.h"

@interface RootViewController ()
@property (nonatomic, weak) IBOutlet MyKnob *knob;
@end

@implementation RootViewController

- (IBAction)doKnob:(id)sender {
    NSLog(@"knob angle is %f", ((MyKnob*)sender).angle);
}

- (void)viewDidLoad {
    // uncomment to see the difference
    // self.knob.continuous = YES;
}

@end
