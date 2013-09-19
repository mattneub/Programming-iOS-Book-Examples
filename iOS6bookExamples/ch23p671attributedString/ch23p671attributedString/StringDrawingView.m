
#import "StringDrawingView.h"

@implementation StringDrawingView

- (void)drawRect:(CGRect)rect
{
    NSString* s1 = @"The Gettysburg Address, as delivered on a certain occasion "
    @"(namely Thursday, November 19, 1863) by A. Lincoln";
    NSString* s2 = @"Fourscore and seven years ago, our fathers brought forth "
    @"upon this continent a new nation, conceived in liberty and dedicated "
    @"to the proposition that all men are created equal.";
    
    s1 = [s1 stringByAppendingString:@"\n"];
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
    
    NSMutableAttributedString* content2 =
    [[NSMutableAttributedString alloc]
     initWithString:s2
     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HoeflerText-Black" size:16]}];
    [content2 setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HoeflerText-Black" size:24]}
                      range:NSMakeRange(0,1)];
    [content2 addAttributes:@{NSKernAttributeName:@-4}
                      range:NSMakeRange(0,1)];
    
    [content appendAttributedString:content2];
    
    // use paragraph styles to dictate our own margins etc.
    
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.headIndent = 10;
    para.firstLineHeadIndent = 10;
    para.tailIndent = -10;
    para.lineBreakMode = NSLineBreakByWordWrapping;
    para.alignment = NSTextAlignmentCenter;
    para.paragraphSpacing = 15;
    [content addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0,1)];
    
    para = [NSMutableParagraphStyle new];
    para.headIndent = 25;
    para.firstLineHeadIndent = 10;
    para.tailIndent = -10;
    para.lineBreakMode = NSLineBreakByWordWrapping;
    para.alignment = NSTextAlignmentJustified;
    //para.hyphenationFactor = 0.9; // causes odd glitch
    [content addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(s1.length,1)];
    
    // draw
    
    NSStringDrawingContext* con = [NSStringDrawingContext new];
    con.minimumScaleFactor = 1;
    con.minimumTrackingAdjustment = 1;
    CGRect r2 = CGRectOffset(self.bounds, 0, 2); // shove start down a little
    [content drawWithRect:r2 options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin context:con];
}

@end
