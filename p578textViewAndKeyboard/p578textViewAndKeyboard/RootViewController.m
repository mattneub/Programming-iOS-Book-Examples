

#import "RootViewController.h"

@implementation RootViewController
@synthesize tv;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [tv release];
    [super dealloc];
}

- (IBAction)doDone:(id)sender {
    [self.view endEditing:NO];
}

-(void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardShow: (NSNotification*) n {
    NSDictionary* d = [n userInfo];
    CGRect r = [[d objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSNumber* curve = [d objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber* duration = [d objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    r = [self.view convertRect:r fromView:nil];
    CGRect f = self.tv.frame;
    self->oldFrame = f;
    f.size.height = self.view.frame.size.height - f.origin.y - r.size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[duration floatValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.tv.frame = f;
    [UIView commitAnimations];
}  

- (void) keyboardHide: (NSNotification*) n {
    NSDictionary* d = [n userInfo];
    NSNumber* curve = [d objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber* duration = [d objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[duration floatValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.tv.frame = self->oldFrame;
    [UIView commitAnimations];
}

@end
