

#import "ViewController.h"
@import CoreText;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIFontDescriptor* desc =
    [UIFontDescriptor fontDescriptorWithName:@"Didot" size:18];
    NSArray* arr =
    @[@{UIFontFeatureTypeIdentifierKey:@(kLetterCaseType),
        UIFontFeatureSelectorIdentifierKey:@(kSmallCapsSelector)}];
    desc =
    [desc fontDescriptorByAddingAttributes:
     @{UIFontDescriptorFeatureSettingsAttribute:arr}];
    UIFont* f = [UIFont fontWithDescriptor:desc size:0];
    self.lab.font = f;
}



@end
