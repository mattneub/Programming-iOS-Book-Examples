

#import "RootViewController.h"

@interface RootViewController()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, weak) IBOutlet UITextView *tv;
@end

@implementation RootViewController

- (void) adjust {
    CGSize sz = self.tv.contentSize;
    self.heightConstraint.constant = sz.height;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self adjust];
}



@end
