

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
    self.label2.attributedText = content;

    self.label3.text = @"The Gettysburg Address by A. Lincoln";
    // two ways of making the text fit:
    // uncomment one or the other
    /*
    self.label3.adjustsLetterSpacingToFitWidth = YES; // new in iOS 6
     */
    /*
    self.label3.adjustsFontSizeToFitWidth = YES;
    self.label3.minimumScaleFactor = 0.8; // new in iOS 6, replaces minimum font size
     */
}


@end
