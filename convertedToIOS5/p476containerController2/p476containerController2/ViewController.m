

#import "ViewController.h"
#import "PanelViewController.h"

@implementation ViewController
@synthesize panel;


#pragma mark - View lifecycle

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    static BOOL done = NO;
    if (!done) {
        done = YES;
        PanelViewController* pvc = [[PanelViewController alloc] init];
        [self addChildViewController:pvc];
        [pvc didMoveToParentViewController:self];
        [self.panel addSubview:pvc.view];
        pvc.view.frame = self.panel.bounds;
        pvc.view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | 
                                     UIViewAutoresizingFlexibleWidth);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
