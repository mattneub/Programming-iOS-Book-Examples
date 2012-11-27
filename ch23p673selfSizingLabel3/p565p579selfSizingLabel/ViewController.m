

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *theLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation ViewController 

/*
 how to change a label's width and get autolayout using its intrinsic size
 */

- (IBAction)doButton:(id)sender {
//    CGRect r = self.theLabel.bounds;
//    r.size.width -= 10;
//    self.theLabel.bounds = r;
//    [self.view setNeedsLayout];
    
    // no, we must alter the constraint itself, in order to get layout
    self.widthConstraint.constant -= 10;
}

// this is the tricky part! there is a two-pass layout operation
// we must adjust the desired layout width and ask for layout again
// comment this out and you'll see the problem: the label doesn't lengthen as it narrows

-(void)viewDidLayoutSubviews {
//    NSLog(@"here");
    self.theLabel.preferredMaxLayoutWidth = self.theLabel.bounds.size.width;
    [self.view layoutSubviews];
}

@end
