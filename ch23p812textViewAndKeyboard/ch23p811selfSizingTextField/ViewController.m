

#import "ViewController.h"

@interface ViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tv;
@property BOOL keyboardShowing;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString* s = @"Twas brillig, and the slithy toves did gyre and gimble in the wabe; "
    @"all mimsy were the borogoves, and the mome raths outgrabe. "
    @"Beware the Jabberwock, my son! "
    @"The jaws that bite, the claws that catch! "
    @"Beware the Jubjub bird, and shun "
    @"the frumious Bandersnatch! "
    @"He took his vorpal sword in hand: "
    @"long time the manxome foe he sought — "
    @"so rested he by the Tumtum tree, "
    @"and stood awhile in thought. "
    @"And as in uffish thought he stood, "
    @"the Jabberwock, with eyes of flame, "
    @"came whiffling through the tulgey wood, "
    @"and burbled as it came! "
    @"One, two! One, two! and through and through "
    @"the vorpal blade went snicker-snack! "
    @"He left it dead, and with its head "
    @"he went galumphing back. "
    @"And hast thou slain the Jabberwock? "
    @"Come to my arms, my beamish boy! "
    @"O frabjous day! Callooh! Callay! "
    @"He chortled in his joy.";
    
    NSMutableAttributedString* mas =
    [[NSMutableAttributedString alloc] initWithString:s
                                           attributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"GillSans" size:20]}];
    
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentLeft;
    para.lineBreakMode = NSLineBreakByWordWrapping;
    [mas addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0,1)];

    self.tv.attributedText = mas;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

-(void)textViewDidChange:(UITextView *)textView {
    // prevent typed characters from going behind keyboard
    // the keyboard should be doing this for us automatically!
    CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
    [textView scrollRectToVisible:r animated:NO];
}

- (void) keyboardShow: (NSNotification*) n {
    NSDictionary* d = [n userInfo];
    CGRect r = [[d objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    r = [self.tv.superview convertRect:r fromView:nil];
    CGRect f = self.tv.frame;
    CGRect fs = self.tv.superview.bounds;
    CGFloat diff = fs.size.height - f.origin.y - f.size.height;
    CGFloat keyboardTop = r.size.height - diff;
    UIEdgeInsets insets = self.tv.contentInset;
    insets.bottom = keyboardTop;
    self.tv.contentInset = insets;
    insets = self.tv.scrollIndicatorInsets;
    insets.bottom = keyboardTop;
    self.tv.scrollIndicatorInsets = insets;
    [self textViewDidChange: self.tv];
    
    self.keyboardShowing = YES;
}

- (IBAction)doDone:(id)sender {
    [self.view endEditing:NO];
}

- (void) keyboardHide: (NSNotification*) n {
    self.keyboardShowing = NO;
    
    NSDictionary* d = [n userInfo];
    NSNumber* curve = d[UIKeyboardAnimationCurveUserInfoKey];
    NSNumber* duration = d[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:duration.floatValue delay:0
                        options:curve.integerValue << 16
                     animations:
     ^{
         [self.tv setContentOffset:CGPointZero];
     } completion:^(BOOL finished) {
         self.tv.contentInset = UIEdgeInsetsZero;
         self.tv.scrollIndicatorInsets = UIEdgeInsetsZero;
     }];
}

-(BOOL)shouldAutorotate {
    return !self.keyboardShowing;
}



@end
