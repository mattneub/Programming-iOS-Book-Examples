

#import "RootViewController.h"

@interface RootViewController()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) IBOutlet UITextView *tv;
@end

@implementation RootViewController

- (void)textViewDidChange:(UITextView *)textView {
    self.heightConstraint.constant = textView.contentSize.height;
}



@end
