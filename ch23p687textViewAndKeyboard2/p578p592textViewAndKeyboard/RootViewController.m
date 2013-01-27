

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) IBOutlet UITextView *tv;
@end

@implementation RootViewController 

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidAppearNOT:(BOOL) animated {
    // playing around with how one might get lined paper effect, not very convincing
    [super viewDidAppear:animated];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20,25), YES, 0);
    [[UIColor yellowColor] setFill];
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextFillRect(con, CGRectMake(0,0,20,25));
    [[UIColor blueColor] setFill];
    CGContextFillRect(con, CGRectMake(0,23,20,1));
    UIImage* pat = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIColor* pcol = [UIColor colorWithPatternImage:pat];    
    self.tv.backgroundColor = pcol;
}


// -----

- (IBAction)doDone:(id)sender {
    [self.view endEditing:NO];
}

- (void) keyboardShow: (NSNotification*) n {
    // the heck with the constraints; the heck with resizing
    // we simply change the insets
    NSDictionary* d = [n userInfo];
    CGRect r = [d[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tv.contentInset = UIEdgeInsetsMake(0,0,r.size.height,0);
    self.tv.scrollIndicatorInsets = UIEdgeInsetsMake(0,0,r.size.height,0);
}

- (void) keyboardHide: (NSNotification*) n {
    NSDictionary* d = [n userInfo];
    NSNumber* curve = d[UIKeyboardAnimationCurveUserInfoKey];
    NSNumber* duration = d[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:duration.floatValue delay:0
                        options:curve.integerValue << 16 // sigh, have to convert here
                     animations:
     ^{
         [self.tv setContentOffset:CGPointZero];
     } completion:^(BOOL finished) {
         self.tv.contentInset = UIEdgeInsetsZero;
         self.tv.scrollIndicatorInsets = UIEdgeInsetsZero;
     }];
}

@end
