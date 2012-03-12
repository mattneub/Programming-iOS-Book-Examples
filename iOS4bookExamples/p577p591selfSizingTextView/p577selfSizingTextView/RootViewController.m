

#import "RootViewController.h"

@implementation RootViewController
@synthesize tv;

- (void)dealloc
{
    [tv release];
    [super dealloc];
}

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
