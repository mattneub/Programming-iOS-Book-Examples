

#import "StyledText.h"
@import CoreText;

@interface StyledText()
@property (nonatomic, copy) NSAttributedString* text;
@end

@implementation StyledText

- (void) awakeFromNib {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"];
    NSString* s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    UIFontDescriptor* desc =
    [UIFontDescriptor fontDescriptorWithName:@"Didot" size:18];
    NSArray* arr =
    @[@{UIFontFeatureTypeIdentifierKey:@(kLetterCaseType),
        UIFontFeatureSelectorIdentifierKey:@(kSmallCapsSelector)}];
    desc =
    [desc fontDescriptorByAddingAttributes:
     @{UIFontDescriptorFeatureSettingsAttribute:arr}];
    UIFont* f = [UIFont fontWithDescriptor:desc size:0];
    NSDictionary* d = @{NSFontAttributeName: f};
    NSMutableAttributedString* mas =
    [[NSMutableAttributedString alloc] initWithString:s attributes:d];
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentCenter;
    [mas addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0,mas.length)];
    self.text = mas;
}

- (void) drawRect:(CGRect)rect {
    CGRect r1 = self.bounds;
    r1.size.width /= 2.0; // column 1
    CGRect r2 = r1;
    r2.origin.x += r2.size.width; // column 2
    NSLayoutManager* lm = [NSLayoutManager new];
    NSTextStorage* ts =
    [[NSTextStorage alloc] initWithAttributedString:self.text];
    [ts addLayoutManager:lm];
    NSTextContainer* tc = [[NSTextContainer alloc] initWithSize:r1.size];
    [lm addTextContainer:tc];
    NSTextContainer* tc2 = [[NSTextContainer alloc] initWithSize:r2.size];
    [lm addTextContainer:tc2];
    NSRange range1 = [lm glyphRangeForTextContainer:tc];
    [lm drawBackgroundForGlyphRange:range1 atPoint:r1.origin];
    [lm drawGlyphsForGlyphRange:range1 atPoint:r1.origin];
    NSRange range2 = [lm glyphRangeForTextContainer:tc2];
    [lm drawBackgroundForGlyphRange:range2 atPoint:r2.origin];
    [lm drawGlyphsForGlyphRange:range2 atPoint:r2.origin];


}



@end
