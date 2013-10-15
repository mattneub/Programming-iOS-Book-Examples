

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doDynamicType:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doDynamicType:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void) doDynamicType: (NSNotification*) n {
    UIFontDescriptor* body =
    [UIFontDescriptor preferredFontDescriptorWithTextStyle:
     UIFontTextStyleBody];
    UIFontDescriptor* emphasis =
    [body fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    UIFont* fbody = [UIFont fontWithDescriptor:body size:0];
    UIFont* femphasis = [UIFont fontWithDescriptor:emphasis size:0];
    NSString* s = self.lab.text;
    NSMutableAttributedString* mas =
    [[NSMutableAttributedString alloc] initWithString:s
                                           attributes:@{NSFontAttributeName:fbody}];
    [mas addAttribute:NSFontAttributeName value:femphasis
                range:[s rangeOfString:@"wild"]];
    self.lab.attributedText = mas;
    
}




@end
