

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
    self.lab.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}


@end
