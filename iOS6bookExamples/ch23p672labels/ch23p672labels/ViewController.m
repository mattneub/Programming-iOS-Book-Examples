

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // old way
    NSString* s1 = @"The Gettysburg Address, as delivered on a certain occasion "
    @"(namely Thursday, November 19, 1863) by A. Lincoln";
    self.label1.text = s1;
    self.label1.numberOfLines = 10;
    self.label1.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    self.label1.textColor = [UIColor colorWithRed:0.251 green:0.000 blue:0.502 alpha:1];
    
    // new way
    self.label2.numberOfLines = 10;
    NSMutableAttributedString* content =
    [[NSMutableAttributedString alloc]
     initWithString:s1
     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:15],
     NSForegroundColorAttributeName:[UIColor colorWithRed:0.251 green:0.000 blue:0.502 alpha:1],
     NSKernAttributeName:[NSNull null]}];
    
    NSRange r = [s1 rangeOfString:@"Gettysburg Address"];
    [content addAttributes: @{NSStrokeColorAttributeName:[UIColor redColor],
NSStrokeWidthAttributeName: @-2.0}
                     range:r];
    
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.lineBreakMode = NSLineBreakByTruncatingMiddle; // not essential, just proving it works
    [content addAttributes: @{NSParagraphStyleAttributeName:para} range:NSMakeRange(0,1)];
    
    self.label2.attributedText = content;

    NSString* s3 = @"The Gettysburg Address by A. Lincoln";
    self.label3.attributedText = [[NSAttributedString alloc] initWithString:s3];
    //self.label3.text = s3;
    // two ways of making the text fit:
    // turn on one or the other
    self.label3.adjustsFontSizeToFitWidth = NO;
    self.label3.minimumScaleFactor = 0.4; // new in iOS 6, replaces minimum font size
    self.label3.adjustsLetterSpacingToFitWidth = NO; // new in iOS 6
    //self.label3.lineBreakMode = NSLineBreakByWordWrapping;
    self.label3.backgroundColor = [UIColor whiteColor];
    self.label3.baselineAdjustment = UIBaselineAdjustmentNone;
}

- (IBAction)doButton:(id)sender {
    // showing that highlightedTextColor doesn't affect attributed string
    self.label1.highlightedTextColor = [UIColor whiteColor];
    self.label1.highlighted = YES;
    // self.label2.text = self.label2.attributedText.string;
    self.label2.highlightedTextColor = [UIColor whiteColor];
    self.label2.highlighted = YES;
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.label1.highlighted = NO;
        self.label2.highlighted = NO;
    });
}

@end
