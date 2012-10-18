

#import "ViewController.h"
#import "PanelViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *panel;
@end

@implementation ViewController {
    BOOL _viewInitializationDone;
}


#pragma mark - View lifecycle

- (void) viewWillLayoutSubviews {
    if (!_viewInitializationDone) {
        _viewInitializationDone = YES;
        PanelViewController* pvc = [[PanelViewController alloc] init];
        [self addChildViewController:pvc];
        [self.panel addSubview:pvc.view];
        pvc.view.frame = self.panel.bounds;
        pvc.view.autoresizingMask = (UIViewAutoresizingFlexibleHeight | 
                                     UIViewAutoresizingFlexibleWidth);
        [pvc didMoveToParentViewController:self];
    }
}

@end
