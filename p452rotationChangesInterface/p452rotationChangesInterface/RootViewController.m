

#import "RootViewController.h"

@implementation RootViewController
@synthesize blackRect;

- (void)dealloc
{
    [blackRect release];
    [super dealloc];
}

- (void) prepareInterface {
    if (!self.blackRect) {
        CGRect f = self.view.bounds;
        f.size.width = f.size.width/3.0;
        UIView* br = [[UIView alloc] initWithFrame:f];
        br.backgroundColor = [UIColor blackColor];
        self.blackRect = br;
        [br release];
    }    
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)io 
                                 duration:(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsPortrait(io))
        [self.blackRect removeFromSuperview];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)io {
    [self prepareInterface];
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) 
        && !self.blackRect.superview)
        [self.view addSubview:self.blackRect];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
