

#import "RootViewController.h"

@interface RootViewController()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) IBOutlet UITextView *tv;
@end

@implementation RootViewController

- (void) adjust {
    CGSize sz = self.tv.contentSize;
    self.heightConstraint.constant = sz.height;
    
    // the old way is NOT the way to do it if you're using auto layout:
    /*
    CGRect f = self.tv.frame;
    f.size.height = sz.height;
    self.tv.frame = f;
     */
    // the reason is that anyone ever calls for layout...
    // [self.view setNeedsLayout];
    // the constraint will come into force and the frame will revert
}

- (void)textViewDidChange:(UITextView *)textView {
    [self adjust];
}



@end
