

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString* s = @"Twas brillig, and the slithy toves did gyre and gimble in the wabe; "
    @"all mimsy were the borogoves, and the mome raths outgrabe.";
    
    NSMutableAttributedString* mas =
    [[NSMutableAttributedString alloc] initWithString:s
                                           attributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"GillSans" size:20]}];
    
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentLeft;
    para.lineBreakMode = NSLineBreakByWordWrapping;
    [mas addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0,1)];

    self.tv.attributedText = mas;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self textViewDidChange:self.tv];
    });
}

-(void)textViewDidChange:(UITextView *)textView {
    // [textView sizeToFit]; // seems no longer needed in iOS 7.1
    self.heightConstraint.constant = textView.contentSize.height;
}



@end
