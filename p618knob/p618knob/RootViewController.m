

#import "RootViewController.h"
#import "MyKnob.h"

@implementation RootViewController
@synthesize knob;

- (IBAction)doKnob:(id)sender {
    NSLog(@"knob angle is %f", ((MyKnob*)sender).angle);
}

- (void)viewDidLoad {
    // uncomment to see the difference
    // self.knob.continuous = YES;
}

- (void)dealloc {
    [knob release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setKnob:nil];
    [super viewDidUnload];
}
@end
