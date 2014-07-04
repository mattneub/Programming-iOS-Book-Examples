

#import "ViewController.h"
@import CoreText;

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

#define which 2

- (void) doDynamicType: (NSNotification*) n {

#if which == 1
    
    UIFontDescriptor* body =
    [UIFontDescriptor preferredFontDescriptorWithTextStyle:
     UIFontTextStyleBody];
    UIFontDescriptor* emphasis =
    [body fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    UIFont* fbody = [UIFont fontWithDescriptor:body size:0];
    UIFont* femphasis = [UIFont fontWithDescriptor:emphasis size:0];
    
#elif which == 2
    
    // this should work but doesn't (bug)
    UIFont* fbody = [UIFont fontWithName:@"GillSans" size:15];
    UIFontDescriptor* emphasis = [fbody.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    UIFont* femphasis = [UIFont fontWithDescriptor:emphasis size:0];
    
#elif which == 3
    
    // the workaround is to drop down to Core Text
    UIFont* fbody = [UIFont fontWithName:@"GillSans" size:15];
    CTFontRef font2 =
    CTFontCreateCopyWithSymbolicTraits (
                                        (__bridge CTFontRef)fbody, 0, nil,
                                        kCTFontItalicTrait, kCTFontItalicTrait);
    UIFont* femphasis = CFBridgingRelease(font2);

#endif
    
    NSString* s = self.lab.text;
    NSMutableAttributedString* mas =
    [[NSMutableAttributedString alloc] initWithString:s
                                           attributes:@{NSFontAttributeName:fbody}];
    [mas addAttribute:NSFontAttributeName value:femphasis
                range:[s rangeOfString:@"wild"]];
    self.lab.attributedText = mas;
    
}




@end
