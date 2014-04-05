

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doDynamicType:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void) doDynamicType: (NSNotification*) n {
    NSString* style = [[self.lab.font fontDescriptor] objectForKey:UIFontDescriptorTextStyleAttribute];
    self.lab.font = [UIFont preferredFontForTextStyle:style];
}


@end
