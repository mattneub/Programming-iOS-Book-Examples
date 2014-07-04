

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property BOOL didSetup;
@end

@implementation ViewController

// storyboard doesn't use autolayout

-(void)viewDidLayoutSubviews {
    if (!_didSetup) {
        _didSetup = YES;
        self.sv.contentSize = ((UIView*)self.sv.subviews[0]).bounds.size;
    }
}

// no code for content inset - automaticallyAdjustsScrollViewInsets takes care of it


@end
