

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) UIView* fr;
@property (nonatomic, strong) IBOutlet UIView *buttonView;

@end

@implementation ViewController {
    UIEdgeInsets _oldContentInset;
    UIEdgeInsets _oldIndicatorInset;
    CGPoint _oldOffset;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)tf {
    self.fr = tf; // keep track of first responder
    tf.inputAccessoryView = self.buttonView;
}

- (void) keyboardShow: (NSNotification*) n {
    self->_oldContentInset = self.scrollView.contentInset;
    self->_oldIndicatorInset = self.scrollView.scrollIndicatorInsets;
    self->_oldOffset = self.scrollView.contentOffset;
    NSDictionary* d = [n userInfo];
    CGRect r = [[d objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    r = [self.scrollView convertRect:r fromView:nil];
    CGRect f = self.fr.frame;
    CGFloat y =
    CGRectGetMaxY(f) + r.size.height - self.scrollView.bounds.size.height + 5;
    if (r.origin.y < CGRectGetMaxY(f))
        [self.scrollView setContentOffset:CGPointMake(0, y) animated:YES];
    UIEdgeInsets insets;
    insets = self.scrollView.contentInset;
    insets.bottom = r.size.height;
    self.scrollView.contentInset = insets;
    insets = self.scrollView.scrollIndicatorInsets;
    insets.bottom = r.size.height;
    self.scrollView.scrollIndicatorInsets = insets;
}

- (BOOL)textFieldShouldReturn: (UITextField*) tf {
    [tf resignFirstResponder];
    return YES;
}

- (void) keyboardHide: (NSNotification*) n {
    [self.scrollView setContentOffset:self->_oldOffset animated:YES];
    [CATransaction setCompletionBlock:^{
        self.scrollView.scrollIndicatorInsets = self->_oldIndicatorInset;
        self.scrollView.contentInset = self->_oldContentInset;
    }];
}

- (IBAction)doNextField:(id)sender {
    NSMutableArray* marr = [NSMutableArray array];
    for (UIView* v in self.fr.superview.subviews) {
        if ([v isKindOfClass: [UITextField class]])
            [marr addObject:v];
    }
    NSUInteger ix = [marr indexOfObject:self.fr];
    if (ix == NSNotFound)
        return;
    ix++;
    if (ix >= [marr count])
        ix = 0;
    UIView* v = marr[ix];
    [v becomeFirstResponder];
}




@end
