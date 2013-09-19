

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (strong, nonatomic) NSAttributedString* content;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString* s1 = @"The Gettysburg Address, as delivered on a certain occasion "
    @"(namely Thursday, November 19, 1863) by A. Lincoln";
    NSMutableAttributedString* content =
    [[NSMutableAttributedString alloc]
     initWithString:s1
     attributes:
     @{
     NSFontAttributeName:
     [UIFont fontWithName:@"Arial-BoldMT" size:15],
     NSKernAttributeName:@0,
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
    @"to the proposition that all men are created equal. Wow";
    // added "Wow" to show autokerning
    NSMutableAttributedString* content2 =
    [[NSMutableAttributedString alloc]
     initWithString:s2
     attributes:
     @{
     NSFontAttributeName:
     [UIFont fontWithName:@"HoeflerText-Black" size:16],
     NSKernAttributeName:[NSNull null] // required to get autokerning
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

    int end = content.length;
    [content replaceCharactersInRange:NSMakeRange(end, 0) withString:@"\n"];
    [content appendAttributedString:content2];
    
    /*
    [content enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0,content.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
        UIFont* font = value;
        if (font.pointSize == 15)
            [content addAttribute:NSFontAttributeName value:[UIFont fontWithName: @"Arial-BoldMT" size:20] range:range];
    }];
     */
    
    self.lab.attributedText = content;
    self.lab.numberOfLines = 0;
    
    self.content = content;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // showing margin-related bug with sizeToFit
    //[self.lab sizeToFit];

    
    //return;
    
    
    // showing margin-related bug with boundingRectWithSize
    // this is probably the basis of the previous bug
    
    CGRect rect = [self.lab.attributedText boundingRectWithSize:self.lab.bounds.size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
    // width is wrong so we have to widen it again

    rect.size.width = self.lab.bounds.size.width;
    rect.size.height += 5;
    
    CGRect f = self.lab.bounds;
    f.size = rect.size;
    self.lab.bounds = f;
    
    return;
    
    // proving that we can just well draw the text ourselves, maybe better
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    [[UIColor whiteColor] setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
    [self.content drawInRect:rect];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* iv = [[UIImageView alloc] initWithImage:im];
    iv.center = self.lab.center;
    iv.frame = CGRectIntegral(iv.frame);
    [self.lab.superview addSubview:iv];
    [self.lab removeFromSuperview];

}


@end
