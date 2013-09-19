

#import "RootViewController.h"
#import "MyTextField.h"

@interface RootViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;
@property (nonatomic, weak) UIView* fr;
@property (nonatomic, strong) IBOutlet UIView *buttonView;
@end


@implementation RootViewController {
    CGFloat oldTopConstant;
    CGFloat oldBottomConstant;
    CGFloat oldScrollViewBottomConstant;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.secondTextField.allowsEditingTextAttributes = YES; // no nib setting for this???!!!
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // look, Ma, no contentSize!
}

- (void)textFieldDidBeginEditing:(UITextField *)tf {
    self.fr = tf; // keep track of first responder
    tf.inputAccessoryView = self.buttonView;
}

- (void) keyboardShow: (NSNotification*) n {
    self->oldTopConstant = self.topConstraint.constant;
    self->oldBottomConstant = self.bottomConstraint.constant;
    self->oldScrollViewBottomConstant = self.scrollViewBottomConstraint.constant;
    
    self.scrollView.bounces = YES;
    NSDictionary* d = [n userInfo];
    CGRect r = [d[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    r = [self.scrollView convertRect:r fromView:nil];
    CGFloat duration = [d[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.topConstraint.constant = 30;
        self.bottomConstraint.constant = 50;
        self.scrollViewBottomConstraint.constant = -r.size.height;
        [self.view layoutIfNeeded];
    }];
    
}

// These text fields dismiss the keyboard automatically
// see p. 574 for the trick used to accomplish this

//- (BOOL)textFieldShouldReturn: (UITextField*) tf {
//    [tf resignFirstResponder];
//    return YES;
//}

- (void) keyboardHide: (NSNotification*) n {
    self.scrollView.bounces = NO;
    NSDictionary* d = [n userInfo];
    CGFloat duration = [d[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.topConstraint.constant = self->oldTopConstant;
        self.bottomConstraint.constant = self->oldBottomConstant;
        self.scrollViewBottomConstraint.constant = self->oldScrollViewBottomConstant;
        [self.view layoutIfNeeded];
    }];

}

// illustrates use of an accessory view (p. 572)
- (IBAction)doNextField:(id)sender {
    if ([self.fr isKindOfClass: [MyTextField class]]) {
        UITextField* nextField = [(MyTextField*)self.fr nextField];
        [nextField becomeFirstResponder];
    }
}

// example of filtering user input

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* lc = [string lowercaseString];
    if ([string isEqualToString:lc])
        return YES;
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:lc];
    return NO;
}


// proving that you can't catch this method here
// you'd need to subclass UITextField, which seems nutty
-(void) toggleBoldface: (id) sender {
    NSLog(@"%@", @"toggling bold");
    [super toggleBoldface:sender];
}


@end
