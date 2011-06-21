
#import "RootViewController.h"
#import "MyProgressView.h"

@implementation RootViewController
@synthesize prog;

- (void)dealloc
{
    [prog release];
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(inc:) userInfo:nil repeats:YES];
}

-(void)inc:(NSTimer*)t {
    CGFloat val = prog.value;
    val += 0.1;
    prog.value = val;
    [prog setNeedsDisplay];
    if (val >= 1.0)
        [t invalidate];
}



@end
