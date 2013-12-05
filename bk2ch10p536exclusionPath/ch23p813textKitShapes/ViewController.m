

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (strong, nonatomic) NSTextContainer* tc;
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
    
    self.tv.attributedText = mas;
    
    self.tv.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 0);
    self.tv.scrollEnabled = NO;
    
}

-(void)viewDidLayoutSubviews {
    

    CGSize sz = self.tv.textContainer.size;
    UIBezierPath* p = [UIBezierPath new];
    [p moveToPoint:CGPointMake(sz.width/4.0,0)];
    [p addLineToPoint:CGPointMake(sz.width,0)];
    [p addLineToPoint:CGPointMake(sz.width,sz.height)];
    [p addLineToPoint:CGPointMake(sz.width/4.0,sz.height)];
    [p addLineToPoint:CGPointMake(sz.width,sz.height/2.0)];
    [p closePath];
    self.tv.textContainer.exclusionPaths = @[p];

}


@end
