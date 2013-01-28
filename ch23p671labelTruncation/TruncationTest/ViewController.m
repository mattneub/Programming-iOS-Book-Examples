

#import "ViewController.h"
#import "MyView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet MyView *vu;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    /*
     Demonstrating the very weird truncating differences between attributed strings and labels
     */
    
    
    NSString *s2 = @"Four score and seven years ago, our fathers brought forth upon this continent a new nation, conceived in liberty, and dedicated to the proposition that all men are created equal.";
    
    NSString* blurb = s2;
    NSMutableAttributedString* content2 = [[NSMutableAttributedString alloc]
                                           initWithString:blurb
                                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Georgia" size:14],
                                           NSKernAttributeName:[NSNull null]}];
    
    NSMutableParagraphStyle* para2 = [NSMutableParagraphStyle new];
    para2.headIndent = 10;
    para2.firstLineHeadIndent = 10;
    para2.tailIndent = -10;
    para2.lineBreakMode = NSLineBreakByWordWrapping;
    para2.paragraphSpacing = 5;
    
    // comment out this next line to see what difference it makes
    para2.lineBreakMode = NSLineBreakByTruncatingTail;
    [content2 addAttribute:NSParagraphStyleAttributeName value:para2 range:NSMakeRange(0,1)];

    // the attributed string draws and truncates only the first line
    self.vu.text = content2;
    
    // the label draws wrapped and truncates the last line
    self.lab.attributedText = content2;
    
    
    
    // ------ but now watch this.... we have *two* paragraphs, with different styles
    
    NSString *s1 = @"The Gettysburg Address, as given by A. Lincoln on a certain occasion\n";
    
    NSString* title = s1;
    NSMutableAttributedString* content = [[NSMutableAttributedString alloc]
                                          initWithString:title
                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:15],
                                          NSForegroundColorAttributeName:[UIColor colorWithRed:0.251 green:0.000 blue:0.502 alpha:1],
                                          NSKernAttributeName:[NSNull null]}];
    
    
    
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.headIndent = 10;
    para.firstLineHeadIndent = 10;
    para.paragraphSpacingBefore = 5;
    para.tailIndent = -10;
    para.lineBreakMode = NSLineBreakByWordWrapping;
    [content addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0,title.length)];

    [content appendAttributedString:content2];
    
    
    // now the label gives up, and the second paragraph draws only its first line, truncated
    
    self.lab2.attributedText = content;
    
    // and here's the fix (thank you, Kyle Sluder); uncomment to use it
    // we must set the label's line break mode *in code*, *after* assigning the attributed text
    
    self.lab2.lineBreakMode = NSLineBreakByTruncatingTail;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
