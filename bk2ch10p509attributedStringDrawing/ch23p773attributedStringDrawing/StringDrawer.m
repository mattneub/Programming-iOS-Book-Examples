
#import "StringDrawer.h"

// not my solution: see http://stackoverflow.com/a/25029448/341994
@implementation NSString (Drawfixer)
+ (NSStringDrawingOptions) combine:(NSStringDrawingOptions)option1 with:(NSStringDrawingOptions)option2
{
    return option1 | option2;
}
@end

// some old code I used to draw with
/*
 NSMutableAttributedString* mas = [self.attributedText mutableCopy];
 NSRange range = [mas.string rangeOfString:@"Four"];
 NSMutableParagraphStyle* para = [mas attribute:NSParagraphStyleAttributeName atIndex:range.location effectiveRange:&range];
 para.lineBreakMode = NSLineBreakByTruncatingTail;
 [mas addAttribute:NSParagraphStyleAttributeName value:para range:range];
 
 [mas drawInRect:r];
*/
