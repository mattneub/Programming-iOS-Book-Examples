
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;

@end

@implementation ViewController

// Looks like the UILabel bug demonstrated here will probably be fixed in iOS 7.1

#define which 0 // try 0, 1, 2, 3, 4, 5

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tv.textContainer.lineFragmentPadding = 0; // make it just like the label
    // to show that under identical conditions they do draw identically
    
    self.tv.scrollEnabled = NO; // for some reason, setting in the nib doesn't always work
    
    // uncomment this to see another interesting workaround for the UILabel display issue
    // let the label resize its own height
    
    /*
    
    [self.lab removeConstraint:self.labelHeight];
    [self.lab addConstraint:
     [NSLayoutConstraint constraintWithItem:self.lab attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:0 multiplier:1 constant:20]];
     
     */
    
#if which == 0 || which == 1 || which == 4 || which == 5

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
    
    self.lab.attributedText = content; // UILabel is empty or only partially drawn
    self.tv.attributedText = content; // UITextView shows the attributed string
    self.tv.contentInset = UIEdgeInsetsMake(20,0,0,0);
    
    /*
    // hmmm, I found an interesting workaround to the UILabel problem
    [content replaceCharactersInRange:NSMakeRange(content.length,0) withString:@"\n\n\n\n\n\n\n\n\n\n"];
    self.lab.attributedText = content;
     */

#endif
#if which == 1 || which == 4 || which == 5
    
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.headIndent = 10;
    para.firstLineHeadIndent = 10;
    para.tailIndent = -10;
    para.lineBreakMode = NSLineBreakByWordWrapping;
    para.alignment = NSTextAlignmentCenter;
    para.paragraphSpacing = 15;
    [content addAttribute:NSParagraphStyleAttributeName
                    value:para range:NSMakeRange(0,1)];
    self.lab.attributedText = content; // UILabel is empty or only partially drawn
    self.tv.attributedText = content; // UITextView shows the attributed string
    self.tv.contentInset = UIEdgeInsetsMake(20,0,0,0);

#endif
#if which == 2 || which == 3 || which == 4 || which == 5
    
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
    [content2 addAttributes:
     @{
       NSFontAttributeName:[UIFont fontWithName:@"HoeflerText-Black" size:24],
       NSExpansionAttributeName:@0.3,
       NSKernAttributeName:@-4
       } range:NSMakeRange(0,1)];
    self.lab.attributedText = content2;
    self.tv.attributedText = content2; // UITextView shows the attributed string
    self.tv.contentInset = UIEdgeInsetsMake(20,0,0,0);


#endif
#if which == 3 || which == 4 || which == 5
    
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
    self.lab.attributedText = content2; // UILabel differs in odd ways
    self.tv.attributedText = content2; // UITextView shows the attributed string
    self.tv.contentInset = UIEdgeInsetsMake(20,0,0,0);

    
#endif
#if which == 4 || which == 5
    
    NSUInteger end = content.length;
    [content replaceCharactersInRange:NSMakeRange(end, 0) withString:@"\n"];
    [content appendAttributedString:content2];
    self.lab.attributedText = content;
    self.tv.attributedText = content;
    self.tv.contentInset = UIEdgeInsetsMake(10,0,0,0);

    
#endif
#if which == 5
    
    // demonstrating efficient cycling through style runs
    [content enumerateAttribute:NSFontAttributeName
                        inRange:NSMakeRange(0,content.length)
                        options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                     usingBlock:^(id value, NSRange range, BOOL *stop)
    {
        UIFont* font = value;
        if (font.pointSize == 15)
            [content addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName: @"Arial-BoldMT" size:20]
                            range:range];
    }];
    self.lab.attributedText = content;
    self.tv.attributedText = content;
    self.tv.contentInset = UIEdgeInsetsMake(10,0,0,0);
    
#endif
    
    
}


@end
