

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tv;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString* s = @"Onions\t$2.34\nPeppers\t$15.2\n";
    NSMutableParagraphStyle* p = [NSMutableParagraphStyle new];
    NSMutableArray* tabs = [NSMutableArray new];
    NSCharacterSet* terms = [NSTextTab columnTerminatorsForLocale:[NSLocale currentLocale]];
    NSTextTab* tab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentRight location:170 options:@{NSTabColumnTerminatorsAttributeName:terms}];
    [tabs addObject:tab];
    p.tabStops = tabs;
    p.firstLineHeadIndent = 20;
    NSMutableAttributedString* mas = [[NSMutableAttributedString alloc] initWithString:s attributes:@{NSFontAttributeName:[UIFont fontWithName:@"GillSans" size:15], NSParagraphStyleAttributeName:p}];
    self.tv.attributedText = mas;
    
}


@end
