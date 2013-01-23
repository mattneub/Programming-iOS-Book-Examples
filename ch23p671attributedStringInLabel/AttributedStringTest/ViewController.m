

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* s1 = @"The Gettysburg Address, as delivered on a certain occasion "
    @"(namely Thursday, November 19, 1863) by A. Lincoln";
    NSMutableAttributedString* content =
    [[NSMutableAttributedString alloc]
     initWithString:s1
     attributes:
     @{
     NSFontAttributeName:
     [UIFont fontWithName:@"Arial-BoldMT" size:15],
     NSForegroundColorAttributeName:
     [UIColor colorWithRed:0.251 green:0.000 blue:0.502 alpha:1]
     }];
    NSRange r = [s1 rangeOfString:@"Gettysburg Address"];
    [content addAttributes:
     @{
NSStrokeColorAttributeName:[UIColor redColor],
NSStrokeWidthAttributeName: @-2.0
     } range:r];

    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.headIndent = 10;
    para.firstLineHeadIndent = 10;
    para.tailIndent = -10;
    para.lineBreakMode = NSLineBreakByWordWrapping;
    para.alignment = NSTextAlignmentCenter;
    para.paragraphSpacing = 15;
    [content addAttribute:NSParagraphStyleAttributeName
                    value:para range:NSMakeRange(0,1)];

    NSString* s2 = @"Fourscore and seven years ago, our fathers brought forth "
    @"upon this continent a new nation, conceived in liberty and dedicated "
    @"to the proposition that all men are created equal.";
    NSMutableAttributedString* content2 =
    [[NSMutableAttributedString alloc]
     initWithString:s2
     attributes:
     @{
     NSFontAttributeName:
     [UIFont fontWithName:@"HoeflerText-Black" size:16]
     }];
    [content2 setAttributes:
     @{
        NSFontAttributeName:[UIFont fontWithName:@"HoeflerText-Black" size:24]
     } range:NSMakeRange(0,1)];
    [content2 addAttributes:
     @{
        NSKernAttributeName:@-4
     } range:NSMakeRange(0,1)];
    
    NSMutableParagraphStyle* para2 = [NSMutableParagraphStyle new];
    para2.headIndent = 10;
    para2.firstLineHeadIndent = 10;
    para2.tailIndent = -10;
    para2.lineBreakMode = NSLineBreakByWordWrapping;
    para2.alignment = NSTextAlignmentJustified;
    para2.lineHeightMultiple = 1.2;
    para2.hyphenationFactor = 1.0;
    [content2 addAttribute:NSParagraphStyleAttributeName
                     value:para2 range:NSMakeRange(0,1)];

    [content.mutableString appendString:@"\n"];
    [content appendAttributedString:content2];
    
    self.lab.attributedText = content;
    self.lab.numberOfLines = 0;
    self.lab.backgroundColor = [UIColor whiteColor];
}


@end
