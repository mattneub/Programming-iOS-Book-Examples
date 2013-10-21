

#import "ViewController.h"
#import "MyLayoutManager.h"

@interface ViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tv;
@property BOOL keyboardShowing;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString* s = @"Twas brillig, and the slithy toves did gyre and gimble in the wabe; "
    @"all mimsy were the borogoves, and the mome raths outgrabe. "
    @"Beware the Jabberwock, my son! "
    @"The jaws that bite, the claws that catch! "
    @"Beware the Jubjub bird, and shun "
    @"the frumious Bandersnatch! "
    @"He took his vorpal sword in hand: "
    @"long time the manxome foe he sought — "
    @"so rested he by the Tumtum tree, "
    @"and stood awhile in thought. "
    @"And as in uffish thought he stood, "
    @"the Jabberwock, with eyes of flame, "
    @"came whiffling through the tulgey wood, "
    @"and burbled as it came! "
    @"One, two! One, two! and through and through "
    @"the vorpal blade went snicker-snack! "
    @"He left it dead, and with its head "
    @"he went galumphing back. "
    @"And hast thou slain the Jabberwock? "
    @"Come to my arms, my beamish boy! "
    @"O frabjous day! Callooh! Callay! "
    @"He chortled in his joy.";
    
    NSMutableAttributedString* mas =
    [[NSMutableAttributedString alloc] initWithString:s
                                           attributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"GillSans" size:20]}];
    
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentLeft;
    para.lineBreakMode = NSLineBreakByWordWrapping;
    [mas addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0,1)];

    CGRect r = self.tv.frame;
    NSLayoutManager* lm = [MyLayoutManager new];
    NSTextStorage* ts = [NSTextStorage new];
    [ts addLayoutManager:lm];
    NSTextContainer* tc =
    [[NSTextContainer alloc]
     initWithSize:CGSizeMake(r.size.width, r.size.height)];
    [lm addTextContainer:tc];
    UITextView* tv = [[UITextView alloc] initWithFrame:r textContainer:tc];
    
    [self.tv removeFromSuperview];
    [self.view addSubview:tv];
    self.tv = tv;
    
    self.tv.attributedText = mas;
    self.tv.scrollEnabled = YES;
    self.tv.backgroundColor = [UIColor yellowColor];
    self.tv.textContainerInset = UIEdgeInsetsMake(20,20,20,20);
    self.tv.selectable = NO;
    self.tv.editable = NO;
    
    self.tv.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[tv]-(10)-|" options:0 metrics:nil views:@{@"tv":self.tv}]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[top][tv]-(10)-[bot]" options:0 metrics:nil views:@{@"tv":self.tv, @"top":self.topLayoutGuide, @"bot":self.bottomLayoutGuide}]];
                                                                                                      
                                                                                                      
                                                                                
}


- (IBAction)doTest:(id)sender {
    
    // how far am I scrolled?
    CGPoint off = self.tv.contentOffset;
    // how far down is the top of the text container?
    CGFloat top = self.tv.textContainerInset.top;
    // so here's the top-left point within the text container
    CGPoint tctopleft = CGPointMake(0, off.y - top);
    // so what's the character index for that?
//    NSUInteger ix = [self.tv.layoutManager characterIndexForPoint:tctopleft inTextContainer:self.tv.textContainer fractionOfDistanceBetweenInsertionPoints:nil];
    NSUInteger ix = [self.tv.layoutManager glyphIndexForPoint:tctopleft inTextContainer:self.tv.textContainer fractionOfDistanceThroughGlyph:nil];
    CGRect frag = [self.tv.layoutManager lineFragmentRectForGlyphAtIndex:ix effectiveRange:nil];
    if (tctopleft.y > frag.origin.y + .5*frag.size.height) {
        tctopleft.y += frag.size.height;
        ix = [self.tv.layoutManager glyphIndexForPoint:tctopleft inTextContainer:self.tv.textContainer fractionOfDistanceThroughGlyph:nil];
    }
    NSRange charRange = [self.tv.layoutManager characterRangeForGlyphRange:NSMakeRange(ix,0) actualGlyphRange:nil];
    ix = charRange.location;
    
    
    // what word is that?
    NSLinguisticTagger* t = [[NSLinguisticTagger alloc] initWithTagSchemes:@[NSLinguisticTagSchemeTokenType] options:0];
    t.string = self.tv.text;
    NSRange r;
    NSString* tag = [t tagAtIndex:ix scheme:NSLinguisticTagSchemeTokenType tokenRange:&r sentenceRange:nil];
    if ([tag isEqualToString: NSLinguisticTagWord])
        NSLog(@"%@", [self.tv.text substringWithRange:r]);
    
    MyLayoutManager* lm = (MyLayoutManager*)self.tv.layoutManager;
    lm.wordRange = r;
    [lm invalidateDisplayForCharacterRange:r];
    
}




@end
