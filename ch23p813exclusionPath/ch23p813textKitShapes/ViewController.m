

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (strong, nonatomic) NSTextContainer* tc;
@end

@implementation ViewController

#define which 2

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
     @{NSFontAttributeName:[UIFont fontWithName:@"GillSans" size:10]}];
    
    NSMutableParagraphStyle* para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentLeft;
    para.lineBreakMode = NSLineBreakByWordWrapping;
    para.hyphenationFactor = 1;
    [mas addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0,1)];
    
    
    self.tv.attributedText = mas;
    
    CGRect r = self.tv.bounds;
    r = CGRectInset(r,20,20);
    
    UIBezierPath* p = [UIBezierPath new];
    [p moveToPoint:CGPointMake(r.size.width/4.0,0)];
    [p addLineToPoint:CGPointMake(r.size.width,0)];
    [p addLineToPoint:CGPointMake(r.size.width,r.size.height)];
    [p addLineToPoint:CGPointMake(r.size.width/4.0,r.size.height)];
    [p addLineToPoint:CGPointMake(r.size.width,r.size.height/2.0)];
    [p closePath];

    self.tv.textContainer.size = r.size;
    self.tv.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    self.tv.textContainer.exclusionPaths = @[p];
    self.tv.layoutManager.allowsNonContiguousLayout = YES;
    
    

    
}


@end
