

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
    self.widthConstraint.constant -= 10;
    self.theLabel.preferredMaxLayoutWidth = self.widthConstraint.constant;
}



@end
