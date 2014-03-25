

#import "StyledText.h"
#import "MyLayoutManager.h"
@import CoreText;

@interface StyledText()
@property (nonatomic, copy) NSAttributedString* text;
@property (nonatomic, strong) NSLayoutManager* lm;
@property (nonatomic, strong) NSTextContainer* tc;
@property (nonatomic, strong) NSTextContainer* tc2;
@property (nonatomic, strong) NSTextStorage* ts;
@property CGRect r1;
@property CGRect r2;
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
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

-(void)layoutSubviews {
    NSLog(@"%@", @"layout");
    [super layoutSubviews];
    CGRect r1 = self.bounds;
    r1.origin.y += 2; // a little top space
    r1.size.width /= 2.0; // column 1
    CGRect r2 = r1;
    r2.origin.x += r2.size.width; // column 2
    NSLayoutManager* lm = [MyLayoutManager new];
    NSTextStorage* ts =
    [[NSTextStorage alloc] initWithAttributedString:self.text];
    [ts addLayoutManager:lm];
    NSTextContainer* tc = [[NSTextContainer alloc] initWithSize:r1.size];
    [lm addTextContainer:tc];
    NSTextContainer* tc2 = [[NSTextContainer alloc] initWithSize:r2.size];
    [lm addTextContainer:tc2];
    
    self.lm = lm;
    self.ts = ts;
    self.tc = tc;
    self.tc2 = tc2;
    self.r1 = r1;
    self.r2 = r2;

}

- (void) drawRect:(CGRect)rect {
    NSRange range1 = [self.lm glyphRangeForTextContainer:self.tc];
    [self.lm drawBackgroundForGlyphRange:range1 atPoint:self.r1.origin];
    [self.lm drawGlyphsForGlyphRange:range1 atPoint:self.r1.origin];
    NSRange range2 = [self.lm glyphRangeForTextContainer:self.tc2];
    [self.lm drawBackgroundForGlyphRange:range2 atPoint:self.r2.origin];
    [self.lm drawGlyphsForGlyphRange:range2 atPoint:self.r2.origin];
}

- (void) tap: (UIGestureRecognizer*) g {
    // which column is it in?
    CGPoint p = [g locationInView:self];
    NSTextContainer* tc = self.tc;
    if (!CGRectContainsPoint(self.r1, p)) {
        tc = self.tc2;
        p.x -= self.r1.size.width;
    }
    CGFloat f;
    NSUInteger ix = [self.lm glyphIndexForPoint:p inTextContainer:tc fractionOfDistanceThroughGlyph:&f];
    NSRange glyphRange;
    [self.lm lineFragmentRectForGlyphAtIndex:ix effectiveRange:&glyphRange];
    // NSLog(@"ix:%lu f:%f glphRange:%@", (unsigned long)ix, f, NSStringFromRange(glyphRange));
    // if ix is the first glyph of the line and f is 0...
    // or ix is the last glyph of the line and f is 1...
    // you missed the word entirely
    if (ix == glyphRange.location && f == 0.0)
        return;
    if (ix == glyphRange.location + glyphRange.length - 1 && f == 1.0)
        return;
    // eliminate control character glyphs at end
    while (NSGlyphPropertyControlCharacter & [self.lm propertyForGlyphAtIndex:glyphRange.location + glyphRange.length - 1])
        glyphRange.length -= 1;
    NSRange characterRange = [self.lm characterRangeForGlyphRange:glyphRange actualGlyphRange:nil];
    NSString* s = [self.text.string substringWithRange:characterRange]; // state name
    NSLog(@"you tapped %@", s);
    MyLayoutManager* lm = (MyLayoutManager*)self.lm;
    lm.wordRange = characterRange;
    [self setNeedsDisplay];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        lm.wordRange = NSMakeRange(0, 0);
        [self setNeedsDisplay];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}



@end
