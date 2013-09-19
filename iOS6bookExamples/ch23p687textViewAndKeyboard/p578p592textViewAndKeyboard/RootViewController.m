

#import "RootViewController.h"

@interface RootViewController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) IBOutlet UITextView *tv;
@end

@implementation RootViewController {
    CGFloat oldBottomConstraint;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

// -----

- (IBAction)doDone:(id)sender {
    [self.view endEditing:NO];
}

- (void) keyboardShow: (NSNotification*) n {
    NSDictionary* d = [n userInfo];
    CGRect r = [d[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSNumber* curve = d[UIKeyboardAnimationCurveUserInfoKey];
    NSNumber* duration = d[UIKeyboardAnimationDurationUserInfoKey];
    r = [self.view convertRect:r fromView:nil];
    [UIView animateWithDuration:duration.floatValue delay:0
                        options:curve.integerValue << 16 // sigh, have to convert here
                     animations:
     ^{
         self->oldBottomConstraint = self.bottomConstraint.constant;
         self.bottomConstraint.constant = -r.size.height;
         [self.view layoutIfNeeded];
     } completion:nil];
}  

- (void) keyboardHide: (NSNotification*) n {
    NSDictionary* d = [n userInfo];
    NSNumber* curve = d[UIKeyboardAnimationCurveUserInfoKey];
    NSNumber* duration = d[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:duration.floatValue delay:0
                        options:curve.integerValue << 16 // sigh, have to convert here
                     animations:
     ^{
         self.bottomConstraint.constant = self->oldBottomConstraint;
         [self.view layoutIfNeeded];
     } completion:nil];
}

@end
