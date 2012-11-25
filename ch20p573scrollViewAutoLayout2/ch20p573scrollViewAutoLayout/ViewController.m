

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@end

@implementation ViewController

/*
 UIScrollView in an auto layout world
 
 Strategy 2:
 We do NOT set the scroll view's contentSize as in the old days.
 The scroll view's contents are constrained so as to dictate the desired size;
 that is, their external constraints are imagined as tied to the scroll view content size,
 and their internal constraints must construct a size from within.
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentViewBottomConstraint.constant = 0;
}

/*
 
 That's all there is to it!!!!!!!!!
 
 */


@end
