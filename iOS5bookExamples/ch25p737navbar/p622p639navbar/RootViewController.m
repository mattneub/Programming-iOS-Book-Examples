
#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, retain) IBOutlet UINavigationBar *nav;
@end

@implementation RootViewController
@synthesize nav;

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationItem* ni = [[UINavigationItem alloc] initWithTitle:@"Tinker"];
    UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Evers"
                                                          style:UIBarButtonItemStyleBordered 
                                                         target:self action:@selector(pushNext:)];
    ni.rightBarButtonItem = b;
    nav.items = [NSArray arrayWithObject: ni]; // nav is the UINavigationBar
}

- (void) pushNext: (id) sender {
    UIBarButtonItem* oldb = sender;
    NSString* s = oldb.title;
    UINavigationItem* ni = [[UINavigationItem alloc] initWithTitle:s];
    if ([s isEqualToString: @"Evers"]) {
        UIBarButtonItem* b = [[UIBarButtonItem alloc] initWithTitle:@"Chance"
                                                              style:UIBarButtonItemStyleBordered 
                                                             target:self action:@selector(pushNext:)];
        ni.rightBarButtonItem = b;
    }
    [nav pushNavigationItem:ni animated:YES];
}


@end
