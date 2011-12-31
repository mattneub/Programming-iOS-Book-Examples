

#import "RootViewController.h"
#import "MyTextField.h"
#import <QuartzCore/QuartzCore.h>

@interface RootViewController ()
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) UIView* fr;
@property (nonatomic, strong) IBOutlet UIView *buttonView;
@end


@implementation RootViewController {
    CGPoint oldOffset;
    UIEdgeInsets oldContentInset;
    UIEdgeInsets oldIndicatorInset;
}
@synthesize buttonView;
@synthesize scrollView, fr;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentSize = self.scrollView.bounds.size;
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
    self->oldContentInset = self.scrollView.contentInset;
    self->oldIndicatorInset = self.scrollView.scrollIndicatorInsets;
    self->oldOffset = self.scrollView.contentOffset;
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

// These text fields dismiss the keyboard automatically
// see p. 574 for the trick used to accomplish this

//- (BOOL)textFieldShouldReturn: (UITextField*) tf {
//    [tf resignFirstResponder];
//    return YES;
//}

- (void) keyboardHide: (NSNotification*) n {
    [self.scrollView setContentOffset:self->oldOffset animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.scrollView.scrollIndicatorInsets = self->oldIndicatorInset;
        self.scrollView.contentInset = self->oldContentInset;  
    });
}

// this next bit could perhaps use a little work to prevent the automatic scrolling
// but it illustrates use of an accessory view which is the point (p. 572)
- (IBAction)doNextField:(id)sender {
    if ([self.fr isKindOfClass: [MyTextField class]]) {
        UITextField* nextField = [(MyTextField*)self.fr nextField];
        [nextField becomeFirstResponder];
    }
}

// new example

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* lc = [string lowercaseString];
    if ([string isEqualToString:lc])
        return YES;
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:lc];
    return NO;
}


@end
