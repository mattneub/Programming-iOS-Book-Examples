

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *innerViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *theLabel;
@property (weak, nonatomic) IBOutlet UIView *innerView;

@end

@implementation ViewController 

/*
 how to change a label's *superview's* width and get autolayout using its intrinsic size
 
 I'm having great trouble doing this; there seems to be a two-cycle layout for labels,
 and I can't seem to get automatic layout of the label to take account of the frame change
 on the same cycle
 
 So my only solution is to use code to force the label's layout width to take account of the
 superview change
 
 This works visibly but is really not sustainable
 
 */

- (IBAction)doButton:(id)sender {
    self.innerViewWidth.constant -= 10;
    self.theLabel.preferredMaxLayoutWidth -=10;
}



@end
