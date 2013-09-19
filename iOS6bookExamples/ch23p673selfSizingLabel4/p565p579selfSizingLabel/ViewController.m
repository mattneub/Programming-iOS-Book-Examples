

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *innerViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *theLabel;
@property (weak, nonatomic) IBOutlet UIView *innerView;

@end

@implementation ViewController 

/*
 how to change a label's *superview's* width and get autolayout using the label's intrinsic size
 */

- (IBAction)doButton:(id)sender {
    self.innerViewWidth.constant -= 10;
}

// see http://stackoverflow.com/questions/13149733/ios-autolayout-issue-with-uilabels-in-a-resizing-parent-view
// the code there didn't work properly, but it did give me this idea

- (void)viewDidLayoutSubviews {
    // wait until *after* constraint-based layout has finished
    dispatch_async(dispatch_get_main_queue(), ^{
        // that way, the label's width is correct when this code executes
        self.theLabel.preferredMaxLayoutWidth = self.theLabel.bounds.size.width;
        // [self.theLabel layoutSubviews];
    });
}


@end
