

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
    para.hyphenationFactor = 1;
    [mas addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0,1)];
    
#define which 2
#if which == 1
    
    CGRect r = self.tv.frame;
    CGRect r2 = self.tv2.frame;
    
    NSTextStorage* ts1 = [[NSTextStorage alloc] initWithAttributedString:mas];
    NSLayoutManager* lm1 = [NSLayoutManager new];
    [ts1 addLayoutManager:lm1];
    NSTextContainer* tc1 = [[NSTextContainer alloc] initWithSize:r.size];
    [lm1 addTextContainer:tc1];
    UITextView* tv = [[UITextView alloc] initWithFrame:r textContainer:tc1];
    tv.scrollEnabled = NO;
    
    NSTextContainer* tc2 = [[NSTextContainer alloc] initWithSize:r2.size];
    [lm1 addTextContainer:tc2];
    UITextView* tv2 = [[UITextView alloc] initWithFrame:r2 textContainer:tc2];
    tv2.scrollEnabled = NO;
    
    [self.tv removeFromSuperview];
    [self.tv2 removeFromSuperview];
    tv.backgroundColor = [UIColor yellowColor];
    tv2.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:tv];
    [self.view addSubview:tv2];
    self.tv = tv;
    self.tv2 = tv2;

    
#elif which == 2
    
    CGRect r = self.tv.frame;
    CGRect r2 = self.tv2.frame;
    
    NSTextStorage* ts1 = [[NSTextStorage alloc] initWithAttributedString:mas];
    NSLayoutManager* lm1 = [NSLayoutManager new];
    [ts1 addLayoutManager:lm1];
    NSLayoutManager* lm2 = [NSLayoutManager new];
    [ts1 addLayoutManager:lm2];
    
    NSTextContainer* tc1 = [[NSTextContainer alloc] initWithSize:r.size];
    NSTextContainer* tc2 = [[NSTextContainer alloc] initWithSize:r2.size];
    [lm1 addTextContainer:tc1];
    [lm2 addTextContainer:tc2];
    
    UITextView* tv = [[UITextView alloc] initWithFrame:r textContainer:tc1];
    UITextView* tv2 = [[UITextView alloc] initWithFrame:r2 textContainer:tc2];
    
    [self.tv removeFromSuperview];
    [self.tv2 removeFromSuperview];
    [self.view addSubview: tv];
    [self.view addSubview: tv2];
    self.tv = tv;
    self.tv2 = tv2;
    tv.backgroundColor = [UIColor yellowColor];
    tv2.backgroundColor = [UIColor yellowColor];



#endif
    
}


@end
