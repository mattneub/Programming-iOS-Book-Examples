

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (weak, nonatomic) IBOutlet UITextView *tv2;
@property (strong, nonatomic) NSLayoutManager* lm;
@property (strong, nonatomic) NSTextStorage* ts;
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
     @{NSFontAttributeName:[UIFont fontWithName:@"GillSans" size:14]}];
    
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentLeft;
    para.lineBreakMode = NSLineBreakByWordWrapping;
    para.hyphenationFactor = 1;
    [mas addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0,1)];
    
#define which 2
#if which == 1
    
    [self.tv.layoutManager removeTextContainerAtIndex:0];
    [self.tv2.layoutManager removeTextContainerAtIndex:0];
    
    NSTextStorage* ts = [[NSTextStorage alloc] initWithAttributedString:mas];
    NSLayoutManager* lm = [NSLayoutManager new];
    [ts addLayoutManager:lm];
    [lm addTextContainer:self.tv.textContainer];
    [lm addTextContainer:self.tv2.textContainer];

    self.ts = ts;
    self.lm = lm;
    
#elif which == 2
    
    NSTextStorage* ts = [[NSTextStorage alloc] initWithAttributedString:mas];
    NSLayoutManager* lm1 = [NSLayoutManager new];
    [ts addLayoutManager:lm1];
    NSLayoutManager* lm2 = [NSLayoutManager new];
    [ts addLayoutManager:lm2];
    CGSize sz1 = self.tv.frame.size;
    CGSize sz2 = self.tv2.frame.size;
    
    NSTextContainer* tc1 = [[NSTextContainer alloc] initWithSize:sz1];
    NSTextContainer* tc2 = [[NSTextContainer alloc] initWithSize:sz2];
    [lm1 addTextContainer:tc1];
    [lm2 addTextContainer:tc2];
    
    UITextView* tv = [[UITextView alloc] initWithFrame:self.tv.frame textContainer:tc1];
    tv.backgroundColor = [UIColor yellowColor];

    UITextView* tv2 = [[UITextView alloc] initWithFrame:self.tv2.frame textContainer:tc2];
    tv2.backgroundColor = [UIColor yellowColor];
    
    [self.tv removeFromSuperview];
    [self.tv2 removeFromSuperview];
    [self.view addSubview: tv];
    [self.view addSubview: tv2];
    self.tv = tv;
    self.tv2 = tv2;

#endif
    
}


@end
