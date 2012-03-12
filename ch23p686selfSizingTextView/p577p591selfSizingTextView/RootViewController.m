

#import "RootViewController.h"

@interface RootViewController()
@property (nonatomic, strong) IBOutlet UITextView *tv;
@end

@implementation RootViewController
@synthesize tv;


- (void) adjust {
    CGSize sz = self.tv.contentSize;
    CGRect f = self.tv.frame;
    f.size = sz;
    self.tv.frame = f;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self adjust];
}



@end
