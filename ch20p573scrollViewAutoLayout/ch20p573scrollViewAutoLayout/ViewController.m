

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray* constraints;
@end

@implementation ViewController {
    BOOL finishedLayout;
}

/*
 UIScrollView in an auto layout world
 
 Strategy 1:
 A UIView stands in for the content view area.
 It *does* translate autoresizing mask into constraints,
 and it must not have other external constraints;
 We set the scroll view's contentSize as in the old days.
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.scrollView removeConstraints:self.constraints];
}

-(void)viewWillLayoutSubviews {
    if (!finishedLayout) {
        finishedLayout = YES;
        self.scrollView.contentSize = self.contentView.bounds.size;
        // [self.view layoutSubviews];
        // NSLog(@"%@", @"here");
    }
}


@end
